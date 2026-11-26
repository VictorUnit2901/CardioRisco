import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../data/local/cardiorisco_repository.dart';
import '../../data/local/local_storage_service.dart';
import '../../data/remote/auth_service.dart';
import '../../data/remote/sync_service.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/services/indicadores_service.dart';
import '../auth/auth_screen.dart';
import '../avaliacao/formulario_avaliacao_screen.dart';
import '../avaliacao/widgets/cabecalho_avaliacao.dart';
import '../comparacao/comparacao_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../evolucao/evolucao_screen.dart';
import '../historico/detalhe_avaliacao_screen.dart';
import '../historico/historico_screen.dart';
import '../relatorios/relatorios_screen.dart';
import '../shared/cores_risco.dart';
import '../shared/widgets_comuns.dart';

/// Tela inicial: resumo, nova avaliação e atalhos para o acompanhamento.
class CardioHomeScreen extends StatefulWidget {
  const CardioHomeScreen({super.key});

  @override
  State<CardioHomeScreen> createState() => _CardioHomeScreenState();
}

class _CardioHomeScreenState extends State<CardioHomeScreen> {
  final _repo = CardioRiscoRepository();
  final _storage = LocalStorageService();
  SyncService? _sync;

  List<AvaliacaoModel> _itens = [];
  bool _temRascunho = false;
  String _nome = 'Profissional';
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
    _iniciarSincronizacao();
  }

  @override
  void dispose() {
    _sync?.pararMonitoramentoAutomatico();
    super.dispose();
  }

  Future<void> _carregar() async {
    final p = await _repo.profissionalAtual();
    // Lista pelo LocalStorageService (mesma fonte que o formulário grava).
    final todas = await _storage.obterAvaliacoesLocais();
    final lista = todas
        .where((a) => p == null || a.profissionalId == p.uid)
        .toList()
      ..sort((a, b) => b.dataHora.compareTo(a.dataHora));
    final rascunho = await _storage.obterRascunho();
    if (!mounted) return;
    setState(() {
      _nome = (p?.nome.isNotEmpty ?? false) ? p!.nome : 'Profissional';
      _itens = lista.where((a) => a.resultado != null).toList();
      _temRascunho = rascunho != null;
      _carregando = false;
    });
  }

  /// Envia as avaliações pendentes quando há Wi-Fi. Se falhar (sem rede,
  /// Firebase indisponível), o app segue funcionando offline.
  Future<void> _iniciarSincronizacao() async {
    try {
      final sync = SyncService();
      _sync = sync;
      sync.iniciarMonitoramentoAutomatico();
      final enviadas = await sync.sincronizarPendentes();
      if (enviadas > 0) await _carregar();
    } catch (_) {
      // Fica na fila e tenta de novo na próxima mudança de conexão.
    }
  }

  Future<void> _sair() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  /// Abre o formulário de avaliação nova. O formulário devolve true quando
  /// a avaliação foi salva; só então a home recarrega os números.
  Future<void> _novaAvaliacao() async {
    final concluiu = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormularioAvaliacaoScreen()),
    );
    if (concluiu == true) await _carregar();
  }

  /// Abre uma tela e recarrega os números quando ela fecha.
  Future<void> _abrir(Widget tela) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    final ind = IndicadoresService.calcular(_itens);
    final pendentes = _itens
        .where((a) => a.statusSync == StatusSincronizacao.pendenteEnvio)
        .length;
    final recentes = _itens.take(3).toList(); // listar() já vem do mais novo

    return Scaffold(
      body: SafeArea(
        child: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregar,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  // Logo da marca (a mesma das telas da avaliação) e ações.
                  Row(
                    children: [
                      const Expanded(child: CabecalhoAvaliacao()),
                      IconButton(
                        tooltip: 'Atualizar',
                        onPressed: _carregar,
                        icon: const Icon(Icons.refresh),
                      ),
                      IconButton(
                        tooltip: 'Sair da conta',
                        onPressed: _sair,
                        icon: const Icon(Icons.logout),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Olá, $_nome',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 5),
                  const Text(
                    'Acompanhamento do risco cardiovascular em 10 anos',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  MetricGrid(itens: [
                    Metrica('Avaliações', '${_itens.length}',
                        Icons.assignment_outlined),
                    Metrica('Pacientes', '${ind.totalPacientes}',
                        Icons.people_outline),
                    Metrica('Alto risco', '${ind.altoRisco}',
                        Icons.warning_amber,
                        cor: ind.altoRisco > 0
                            ? AppTheme.dangerRed
                            : AppTheme.primaryGreen),
                  ]),
                  if (pendentes > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.cloud_upload_outlined,
                            size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 6),
                        Text('$pendentes aguardando envio (Wi-Fi)',
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  // Avaliação nova. Se existir rascunho, o formulário o retoma.
                  ElevatedButton.icon(
                    onPressed: _novaAvaliacao,
                    icon: Icon(_temRascunho ? Icons.play_arrow : Icons.add),
                    label: Text(_temRascunho
                        ? 'CONTINUAR AVALIAÇÃO EM ANDAMENTO'
                        : 'NOVA AVALIAÇÃO'),
                  ),
                  const SizedBox(height: 22),
                  if (recentes.isNotEmpty) ...[
                    const TituloSecao('Últimas avaliações'),
                    for (final a in recentes) _Recente(a: a, onTap: () =>
                        _abrir(DetalheAvaliacaoScreen(avaliacao: a))),
                    const SizedBox(height: 14),
                  ] else ...[
                    const EstadoVazio(
                      'Nenhuma avaliação concluída ainda. Toque em "Nova avaliação" para começar.',
                      icone: Icons.favorite_border,
                    ),
                  ],
                  const TituloSecao('Acompanhamento'),
                  AtalhoTile(
                    icone: Icons.history,
                    titulo: 'Histórico completo',
                    subtitulo: 'Consultar, editar e excluir avaliações',
                    onTap: () => _abrir(const HistoricoScreen()),
                  ),
                  AtalhoTile(
                    icone: Icons.compare_arrows,
                    titulo: 'Comparar avaliações',
                    subtitulo: 'Duas avaliações do mesmo paciente',
                    onTap: () => _abrir(const ComparacaoScreen()),
                  ),
                  AtalhoTile(
                    icone: Icons.show_chart,
                    titulo: 'Gráfico de evolução',
                    subtitulo: 'Risco do paciente ao longo do tempo',
                    onTap: () => _abrir(const EvolucaoScreen()),
                  ),
                  AtalhoTile(
                    icone: Icons.donut_large,
                    titulo: 'Dashboard do ACS',
                    subtitulo: 'Indicadores e fatores de risco',
                    onTap: () => _abrir(const DashboardScreen()),
                  ),
                  AtalhoTile(
                    icone: Icons.analytics_outlined,
                    titulo: 'Relatórios epidemiológicos',
                    subtitulo: 'Dados agregados e relatório em PDF',
                    onTap: () => _abrir(const RelatoriosScreen()),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

class _Recente extends StatelessWidget {
  const _Recente({required this.a, required this.onTap});
  final AvaliacaoModel a;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = a.resultado!;
    final cor = corDoNivel(r.nivel);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.favorite, color: cor),
        title: Text(a.codigoPaciente),
        subtitle: Text(formatarData(a.dataHora)),
        trailing: Text(
          '${formatarPercentual(r.percentual)} • ${r.nivel.rotulo}',
          style: TextStyle(color: cor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

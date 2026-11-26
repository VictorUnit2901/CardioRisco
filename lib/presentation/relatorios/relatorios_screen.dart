import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../data/local/cardiorisco_repository.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../../domain/services/indicadores_service.dart';
import '../../domain/services/relatorio_pdf_service.dart';
import '../shared/avaliacoes_loader.dart';
import '../shared/cores_risco.dart';
import '../shared/widgets_comuns.dart';
import 'pdf_preview_screen.dart';

/// Relatório epidemiológico agregado (sem identificar pacientes) + PDF.
class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  static const _periodos = <String, int?>{
    'Todo o período': null,
    'Últimos 30 dias': 30,
    'Últimos 90 dias': 90,
  };
  String _periodo = 'Todo o período';

  Future<void> _abrirPdf(Indicadores ind) async {
    final profissional = await CardioRiscoRepository().profissionalAtual();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          titulo: 'Relatório em PDF',
          nomeArquivo: 'relatorio_cardiorisco.pdf',
          gerar: () => RelatorioPdfService.agregado(
            ind: ind,
            periodo: _periodo,
            profissional: profissional,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios epidemiológicos')),
      body: AvaliacoesLoader(
        apenasConcluidas: true,
        builder: (context, todas, _) {
          final ind = IndicadoresService.calcular(todas,
              ultimosDias: _periodos[_periodo]);
          final n = ind.totalPacientes;

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              DropdownButtonFormField<String>(
                key: ValueKey(_periodo),
                initialValue: _periodo,
                decoration: const InputDecoration(labelText: 'Período'),
                items: [
                  for (final p in _periodos.keys)
                    DropdownMenuItem(value: p, child: Text(p)),
                ],
                onChanged: (v) => setState(() => _periodo = v ?? _periodo),
              ),
              const SizedBox(height: 18),
              if (n == 0)
                const EstadoVazio(
                  'Nenhuma avaliação concluída neste período.',
                  icone: Icons.analytics_outlined,
                )
              else ...[
                LinhaInfo('Avaliações concluídas', '${ind.totalAvaliacoes}'),
                LinhaInfo('Pacientes avaliados', '$n'),
                LinhaInfo('Risco médio agregado', formatarPercentual(ind.riscoMedio)),
                const SizedBox(height: 10),
                const TituloSecao('Classificação de risco'),
                for (final nivel in NivelRisco.values)
                  _BarraProporcao(
                    rotulo: nivel.rotulo,
                    valor: ind.nivel(nivel),
                    total: n,
                    cor: corDoNivel(nivel),
                  ),
                const SizedBox(height: 10),
                const TituloSecao('Fatores de risco'),
                _BarraProporcao(
                    rotulo: 'Fumantes',
                    valor: ind.fumantes,
                    total: n,
                    cor: AppTheme.dangerRed),
                _BarraProporcao(
                    rotulo: 'Diabetes',
                    valor: ind.diabeticos,
                    total: n,
                    cor: AppTheme.dangerRed),
                _BarraProporcao(
                    rotulo: 'Remédio p/ pressão',
                    valor: ind.usamRemedioPressao,
                    total: n,
                    cor: AppTheme.warningYellow),
                const SizedBox(height: 10),
                const TituloSecao('Faixa etária'),
                for (final f in IndicadoresService.faixasEtarias)
                  _BarraProporcao(
                    rotulo: f,
                    valor: ind.porFaixaEtaria[f] ?? 0,
                    total: n,
                    cor: AppTheme.primaryGreen,
                  ),
                const SizedBox(height: 10),
                const TituloSecao('Médias clínicas'),
                if (ind.pressaoMedia != null)
                  LinhaInfo('Pressão sistólica',
                      '${formatarNumero(ind.pressaoMedia!, casas: 0)} mmHg'),
                if (ind.colesterolMedio != null)
                  LinhaInfo('Colesterol total',
                      '${formatarNumero(ind.colesterolMedio!, casas: 0)} mg/dL'),
                if (ind.hdlMedio != null)
                  LinhaInfo('HDL', '${formatarNumero(ind.hdlMedio!, casas: 0)} mg/dL'),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () => _abrirPdf(ind),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('GERAR RELATÓRIO EM PDF'),
                ),
              ],
              const SizedBox(height: 12),
              const Text(
                'Relatório agregado e anonimizado: cada paciente conta uma vez, pela avaliação mais recente. '
                'Cobre só as avaliações deste profissional neste aparelho, não toda a UBS.',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BarraProporcao extends StatelessWidget {
  const _BarraProporcao({
    required this.rotulo,
    required this.valor,
    required this.total,
    required this.cor,
  });
  final String rotulo;
  final int valor;
  final int total;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    final fracao = total == 0 ? 0.0 : valor / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(rotulo),
              Text('$valor (${proporcao(valor, total)})',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fracao,
              minHeight: 8,
              color: cor,
              backgroundColor: AppTheme.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

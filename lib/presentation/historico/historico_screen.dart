import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../data/local/cardiorisco_repository.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../avaliacao/formulario_avaliacao_screen.dart';
import '../avaliacao/widgets/cabecalho_avaliacao.dart';
import '../shared/avaliacoes_loader.dart';
import '../shared/cores_risco.dart';
import '../shared/widgets_comuns.dart';
import 'detalhe_avaliacao_screen.dart';

/// Lista completa: buscar, ver, editar (pelo formulário) e excluir.
class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final _repo = CardioRiscoRepository();
  final _busca = TextEditingController();
  NivelRisco? _nivel; // null = todos

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  Future<void> _ver(AvaliacaoModel a, Future<void> Function() recarregar) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalheAvaliacaoScreen(avaliacao: a)),
    );
    await recarregar();
  }

  Future<void> _editar(
      AvaliacaoModel a, Future<void> Function() recarregar) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => FormularioAvaliacaoScreen(avaliacao: a)),
    );
    await recarregar();
  }

  Future<void> _excluir(
      AvaliacaoModel a, Future<void> Function() recarregar) async {
    final confirmou = await confirmarExclusao(context, a);
    if (!confirmou) return;
    await _repo.excluir(a.id);
    await recarregar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Avaliação ${a.codigoPaciente} excluída.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Logo da marca com o botão de voltar, como nas telas da avaliação.
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: CabecalhoAvaliacao(
                aoVoltar: () => Navigator.of(context).pop(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Histórico',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            Expanded(
              child: AvaliacoesLoader(
        apenasConcluidas: true,
        builder: (context, todas, recarregar) {
          final q = _busca.text.trim().toLowerCase();
          final lista = todas.where((a) {
            final bateBusca = a.codigoPaciente.toLowerCase().contains(q);
            final bateNivel = _nivel == null || a.resultado!.nivel == _nivel;
            return bateBusca && bateNivel;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _busca,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Buscar por código do paciente',
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _chip('Todas', _nivel == null, () => setState(() => _nivel = null)),
                    for (final n in NivelRisco.values)
                      _chip(n.rotulo, _nivel == n, () => setState(() => _nivel = n)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${lista.length} avaliação(ões)',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                ),
              ),
              Expanded(
                child: lista.isEmpty
                    ? EstadoVazio(
                        todas.isEmpty
                            ? 'Nenhuma avaliação concluída ainda.'
                            : 'Nenhuma avaliação encontrada com esse filtro.',
                        icone: Icons.history,
                      )
                    : RefreshIndicator(
                        onRefresh: recarregar,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                          itemCount: lista.length,
                          itemBuilder: (ctx, i) =>
                              _item(lista[i], recarregar),
                        ),
                      ),
              ),
            ],
          );
        },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String texto, bool ativo, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: ChoiceChip(
          label: Text(texto),
          selected: ativo,
          onSelected: (_) => onTap(),
        ),
      );

  Widget _item(AvaliacaoModel a, Future<void> Function() recarregar) {
    final r = a.resultado!;
    final cor = corDoNivel(r.nivel);
    return Card(
      child: ListTile(
        onTap: () => _ver(a, recarregar),
        leading: CircleAvatar(
          backgroundColor: cor.withValues(alpha: 0.18),
          child: Text('${r.percentual.round()}%',
              style: TextStyle(
                  color: cor, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        title: Text(a.codigoPaciente),
        subtitle: Text(
            '${formatarData(a.dataHora)} • ${formatarPercentual(r.percentual)} • ${r.nivel.rotulo}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: _textoSync(a.statusSync),
              child: Icon(_iconeSync(a.statusSync),
                  size: 18, color: AppTheme.textSecondary),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'ver') _ver(a, recarregar);
                if (v == 'editar') _editar(a, recarregar);
                if (v == 'excluir') _excluir(a, recarregar);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'ver', child: Text('Ver detalhes')),
                PopupMenuItem(value: 'editar', child: Text('Editar')),
                PopupMenuItem(value: 'excluir', child: Text('Excluir')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconeSync(StatusSincronizacao s) {
  switch (s) {
    case StatusSincronizacao.sincronizado:
      return Icons.cloud_done_outlined;
    case StatusSincronizacao.pendenteEnvio:
      return Icons.cloud_upload_outlined;
    case StatusSincronizacao.rascunho:
      return Icons.edit_note;
  }
}

String _textoSync(StatusSincronizacao s) {
  switch (s) {
    case StatusSincronizacao.sincronizado:
      return 'Enviada à nuvem';
    case StatusSincronizacao.pendenteEnvio:
      return 'Aguardando envio (Wi-Fi)';
    case StatusSincronizacao.rascunho:
      return 'Rascunho';
  }
}

/// Pergunta antes de excluir. Devolve true se a pessoa confirmou.
Future<bool> confirmarExclusao(BuildContext context, AvaliacaoModel a) async {
  final jaEnviada = a.statusSync == StatusSincronizacao.sincronizado;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Excluir avaliação?'),
      content: Text(
        'A avaliação de ${a.codigoPaciente} (${formatarData(a.dataHora)}) '
        'será removida deste aparelho.'
        '${jaEnviada ? '\n\nEla já foi enviada à nuvem e a cópia de lá não é apagada por aqui.' : ''}',
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppTheme.dangerRed),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
  return ok == true;
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/local/local_storage_service.dart';
import '../../data/remote/sync_service.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../../domain/models/recomendacao.dart';
import '../../domain/services/gerador_recomendacoes.dart';
import 'widgets/cabecalho_avaliacao.dart';
import 'widgets/estilo_risco.dart';

/// Tela 4 do fluxo principal: encaminhamento e recomendações
/// personalizadas. O botão "Concluir" salva a avaliação na fila do
/// aparelho (para ser enviada no Wi-Fi) e apaga o rascunho.
///
/// Ao concluir, fecha com o resultado `true`. A Tela 3 e o formulário
/// usam isso para fechar também e voltar ao início.
class RecomendacoesScreen extends StatefulWidget {
  const RecomendacoesScreen({
    super.key,
    required this.avaliacao,
    this.armazenamento,
    this.enviarPendentes,
  });

  /// Avaliação já calculada (com resultado).
  final AvaliacaoModel avaliacao;

  /// Onde salvar a avaliação. Os testes passam um armazenamento próprio.
  final LocalStorageService? armazenamento;

  /// Tenta enviar a fila ao Firestore logo depois de salvar. Se for null,
  /// usa o SyncService do João. Os testes passam uma função falsa.
  final Future<void> Function()? enviarPendentes;

  @override
  State<RecomendacoesScreen> createState() => _RecomendacoesScreenState();
}

class _RecomendacoesScreenState extends State<RecomendacoesScreen> {
  bool _salvando = false;

  Future<void> _concluir() async {
    setState(() => _salvando = true);
    final armazenamento = widget.armazenamento ?? LocalStorageService();
    // Uma avaliação nova ainda está como rascunho. Se já estava salva,
    // é uma edição vinda do histórico: aí o rascunho (de outra
    // avaliação em andamento) não pode ser apagado.
    final ehNova = widget.avaliacao.statusSync == StatusSincronizacao.rascunho;

    try {
      await armazenamento.salvarAvaliacaoNaFila(widget.avaliacao);
      if (ehNova) {
        await armazenamento.limparRascunho();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a avaliação. Tente de novo.'),
        ),
      );
      return;
    }

    // Não espera o envio: se não houver Wi-Fi, a avaliação fica na fila.
    unawaited(_tentarEnviarAgora());

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Avaliação salva neste aparelho. Será enviada quando houver Wi-Fi.',
        ),
      ),
    );
    Navigator.of(context).pop(true);
  }

  Future<void> _tentarEnviarAgora() async {
    try {
      final enviar = widget.enviarPendentes;
      if (enviar != null) {
        await enviar();
      } else {
        // sincronizarTudo respeita a regra de enviar só no Wi-Fi e não
        // roda duas sincronizações ao mesmo tempo.
        await SyncService().sincronizarTudo(
          profissionalId: widget.avaliacao.profissionalId,
        );
      }
    } catch (_) {
      // Sem Firebase, sem login ou sem rede: a avaliação continua na fila
      // e o SyncService envia depois.
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultado = widget.avaliacao.resultado;
    if (resultado == null) {
      return const Scaffold(
        body: Center(child: Text('Esta avaliação ainda não tem resultado.')),
      );
    }

    final recomendacoes = const GeradorRecomendacoes().gerar(widget.avaliacao);
    final encaminhamento = recomendacoes
        .where((r) => r.tipo == TipoRecomendacao.encaminhamento)
        .firstOrNull;
    final estiloDeVida = recomendacoes
        .where((r) => r.tipo == TipoRecomendacao.estiloDeVida)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CabecalhoAvaliacao(
                aoVoltar: _salvando ? null : () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recomendações',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _CartaoResumo(
                nivel: resultado.nivel,
                percentual: resultado.percentualFormatado(),
                encaminhamento: encaminhamento,
              ),
              const SizedBox(height: 20),
              for (final recomendacao in estiloDeVida)
                _CartaoRecomendacao(recomendacao: recomendacao),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _salvando ? null : _concluir,
                child: _salvando
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Text('CONCLUIR E VOLTAR AO INÍCIO'),
              ),
              const SizedBox(height: 14),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.cloud_off_outlined,
                      color: AppTheme.textSecondary, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ao concluir, a avaliação fica salva neste aparelho e é '
                      'enviada automaticamente quando houver Wi-Fi.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cartão do topo: nível, percentual e encaminhamento sugerido.
class _CartaoResumo extends StatelessWidget {
  const _CartaoResumo({
    required this.nivel,
    required this.percentual,
    required this.encaminhamento,
  });

  final NivelRisco nivel;
  final String percentual;
  final Recomendacao? encaminhamento;

  @override
  Widget build(BuildContext context) {
    final encaminhamento = this.encaminhamento;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: nivel.cor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: nivel.cor.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: nivel.cor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'RISCO ${nivel.rotulo.toUpperCase()}',
                  style: TextStyle(
                    color: nivel.cor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$percentual em 10 anos',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (encaminhamento != null) ...[
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  encaminhamento.tema.icone,
                  color: nivel.cor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${encaminhamento.titulo}: ${encaminhamento.descricao}',
                    style: const TextStyle(fontSize: 16, height: 1.35),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Cartão de uma recomendação de estilo de vida, com a faixa colorida
/// à esquerda. Ao tocar, mostra a explicação completa.
class _CartaoRecomendacao extends StatelessWidget {
  const _CartaoRecomendacao({required this.recomendacao});

  final Recomendacao recomendacao;

  @override
  Widget build(BuildContext context) {
    final cor = recomendacao.tema.cor;
    final borda = BorderRadius.circular(14);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppTheme.surface,
        borderRadius: borda,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _mostrarDetalhe(context),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: cor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(recomendacao.tema.icone, color: cor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recomendacao.titulo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recomendacao.descricao,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: cor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarDetalhe(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(recomendacao.tema.icone, color: recomendacao.tema.cor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      recomendacao.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recomendacao.detalhe,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

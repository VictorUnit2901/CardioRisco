import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Indicador de etapas do formulário, como no protótipo: uma bolinha
/// numerada por etapa, ligadas por uma linha, com o nome embaixo.
///
/// - Etapa concluída: bolinha verde com um "check".
/// - Etapa atual: bolinha verde com o número.
/// - Etapa futura: bolinha cinza com o número.
class IndicadorEtapas extends StatelessWidget {
  const IndicadorEtapas({
    super.key,
    required this.etapaAtual,
    this.rotulos = const ['Dados pessoais', 'Dados clínicos'],
  });

  final int etapaAtual;
  final List<String> rotulos;

  static const double _tamanho = 40;

  @override
  Widget build(BuildContext context) {
    final total = rotulos.length;
    return Semantics(
      label: 'Etapa $etapaAtual de $total: ${rotulos[etapaAtual - 1]}',
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, limites) {
            // Cada etapa ocupa uma coluna; a bolinha fica no meio dela.
            final coluna = limites.maxWidth / total;
            final metadeLinha = (coluna - _tamanho) / 2;
            return SizedBox(
              height: 72,
              child: Stack(
                children: [
                  // Linhas entre as bolinhas. A metade da esquerda fica
                  // verde quando a etapa começa; a da direita, quando a
                  // próxima etapa começa.
                  for (var i = 0; i < total - 1; i++) ...[
                    _linha(
                      esquerda: coluna * i + coluna / 2 + _tamanho / 2,
                      largura: metadeLinha,
                      ativa: etapaAtual >= i + 1,
                    ),
                    _linha(
                      esquerda: coluna * i + coluna / 2 + _tamanho / 2 +
                          metadeLinha,
                      largura: metadeLinha,
                      ativa: etapaAtual >= i + 2,
                    ),
                  ],
                  for (var i = 0; i < total; i++)
                    Positioned(
                      left: coluna * i,
                      width: coluna,
                      top: 0,
                      child: Column(
                        children: [
                          _Bolinha(numero: i + 1, etapaAtual: etapaAtual),
                          const SizedBox(height: 8),
                          Text(
                            rotulos[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: i + 1 <= etapaAtual
                                  ? AppTheme.primaryGreen
                                  : AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _linha({
    required double esquerda,
    required double largura,
    required bool ativa,
  }) {
    return Positioned(
      left: esquerda,
      width: largura,
      top: _tamanho / 2 - 1.5,
      child: Container(
        height: 3,
        color: ativa ? AppTheme.primaryGreen : AppTheme.surfaceVariant,
      ),
    );
  }
}

class _Bolinha extends StatelessWidget {
  const _Bolinha({required this.numero, required this.etapaAtual});

  final int numero;
  final int etapaAtual;

  @override
  Widget build(BuildContext context) {
    final concluida = numero < etapaAtual;
    final ativa = numero <= etapaAtual;
    return Container(
      width: IndicadorEtapas._tamanho,
      height: IndicadorEtapas._tamanho,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ativa ? AppTheme.primaryGreen : AppTheme.surfaceVariant,
      ),
      child: concluida
          ? const Icon(Icons.check, color: AppTheme.background, size: 22)
          : Text(
              '$numero',
              style: TextStyle(
                color: ativa ? AppTheme.background : AppTheme.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Barra de progresso do formulário: "Etapa 1 de 2" e um traço por etapa.
/// As etapas já alcançadas ficam verdes.
class IndicadorEtapas extends StatelessWidget {
  const IndicadorEtapas({
    super.key,
    required this.etapaAtual,
    this.totalEtapas = 2,
  });

  final int etapaAtual;
  final int totalEtapas;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Etapa $etapaAtual de $totalEtapas',
          style: const TextStyle(
            color: AppTheme.primaryGreen,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 1; i <= totalEtapas; i++) ...[
              if (i > 1) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: i <= etapaAtual
                        ? AppTheme.primaryGreen
                        : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

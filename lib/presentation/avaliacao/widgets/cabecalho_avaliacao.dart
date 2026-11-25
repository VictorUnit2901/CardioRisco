import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Cabeçalho das telas da avaliação, como no protótipo: botão de voltar
/// (opcional), a marca "CardioRisco" e o subtítulo.
class CabecalhoAvaliacao extends StatelessWidget {
  const CabecalhoAvaliacao({super.key, this.aoVoltar});

  /// Se for null, o botão de voltar não aparece.
  final VoidCallback? aoVoltar;

  @override
  Widget build(BuildContext context) {
    final aoVoltar = this.aoVoltar;
    return Row(
      children: [
        if (aoVoltar != null) ...[
          Material(
            color: AppTheme.surface,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: aoVoltar,
              tooltip: 'Voltar',
              icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            ),
          ),
          const SizedBox(width: 12),
        ],
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monitor_heart_outlined,
                    color: AppTheme.dangerRed, size: 24),
                SizedBox(width: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Cardio',
                        style: TextStyle(color: AppTheme.textPrimary),
                      ),
                      TextSpan(
                        text: 'Risco',
                        style: TextStyle(color: AppTheme.dangerRed),
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              'AVALIAÇÃO CARDIOVASCULAR',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

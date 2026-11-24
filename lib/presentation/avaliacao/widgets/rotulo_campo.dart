import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Título de uma pergunta do formulário (ex.: "1. Idade"), com uma
/// explicação curta opcional embaixo.
class RotuloCampo extends StatelessWidget {
  const RotuloCampo(this.texto, {super.key, this.dica});

  final String texto;
  final String? dica;

  @override
  Widget build(BuildContext context) {
    final dica = this.dica;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (dica != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                dica,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

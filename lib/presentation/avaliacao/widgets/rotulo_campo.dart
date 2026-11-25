import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Título de uma pergunta do formulário (ex.: "1. Idade"), com um ícone
/// opcional antes e uma explicação curta opcional embaixo.
class RotuloCampo extends StatelessWidget {
  const RotuloCampo(this.texto, {super.key, this.dica, this.icone});

  final String texto;
  final String? dica;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    final dica = this.dica;
    final icone = this.icone;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icone != null) ...[
                Icon(icone, color: AppTheme.textSecondary, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  texto,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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

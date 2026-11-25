import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';

/// Campo para números inteiros (idade, pressão, colesterol, HDL).
///
/// Tolerante a erros de digitação: abre o teclado numérico, ignora
/// letras, vírgulas, pontos e espaços, e aceita no máximo 3 dígitos.
class CampoNumerico extends StatelessWidget {
  const CampoNumerico({
    super.key,
    required this.controller,
    required this.onChanged,
    this.sufixo,
    this.exemplo,
    this.ajuda,
    this.icone,
    this.acao = TextInputAction.next,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// Unidade mostrada no fim do campo (ex.: "mmHg").
  final String? sufixo;

  /// Texto de exemplo mostrado enquanto o campo está vazio.
  final String? exemplo;

  /// Explicação curta mostrada embaixo do campo.
  final String? ajuda;

  /// Ícone mostrado dentro do campo, à esquerda (opcional).
  final IconData? icone;

  /// O que o botão do teclado faz: ir para o próximo campo ou concluir.
  final TextInputAction acao;

  @override
  Widget build(BuildContext context) {
    final icone = this.icone;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      textInputAction: acao,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: exemplo,
        hintStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        suffixText: sufixo,
        helperText: ajuda,
        helperMaxLines: 2,
        helperStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        prefixIcon: icone == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 6),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icone, color: AppTheme.primaryGreen, size: 20),
                ),
              ),
      ),
    );
  }
}

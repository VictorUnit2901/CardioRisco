import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.acao = TextInputAction.next,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// Unidade mostrada no fim do campo (ex.: "mmHg").
  final String? sufixo;

  /// Texto de exemplo mostrado enquanto o campo está vazio.
  final String? exemplo;

  /// O que o botão do teclado faz: ir para o próximo campo ou concluir.
  final TextInputAction acao;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      textInputAction: acao,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: exemplo,
        suffixText: sufixo,
      ),
    );
  }
}

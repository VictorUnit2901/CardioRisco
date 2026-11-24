import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Dois botões grandes lado a lado para respostas do tipo Sim/Não
/// ou Masculino/Feminino. Botões grandes são mais fáceis de tocar
/// durante a visita do que caixas pequenas.
///
/// [selecionado] é true quando a opção A está marcada, false quando a
/// opção B está marcada e null quando nada foi respondido ainda.
class SeletorDuasOpcoes extends StatelessWidget {
  const SeletorDuasOpcoes({
    super.key,
    required this.opcaoA,
    required this.opcaoB,
    required this.selecionado,
    required this.onChanged,
  });

  final String opcaoA;
  final String opcaoB;
  final bool? selecionado;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Opcao(
            texto: opcaoA,
            ativa: selecionado == true,
            aoTocar: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Opcao(
            texto: opcaoB,
            ativa: selecionado == false,
            aoTocar: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _Opcao extends StatelessWidget {
  const _Opcao({
    required this.texto,
    required this.ativa,
    required this.aoTocar,
  });

  final String texto;
  final bool ativa;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final borda = BorderRadius.circular(10);
    return Semantics(
      button: true,
      selected: ativa,
      child: Material(
        color: ativa
            ? AppTheme.primaryGreen.withValues(alpha: 0.15)
            : AppTheme.surface,
        borderRadius: borda,
        child: InkWell(
          borderRadius: borda,
          onTap: aoTocar,
          child: Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: borda,
              border: Border.all(
                color: ativa ? AppTheme.primaryGreen : AppTheme.surfaceVariant,
                width: ativa ? 2 : 1,
              ),
            ),
            child: Text(
              texto,
              style: TextStyle(
                color: ativa ? AppTheme.primaryGreen : AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: ativa ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

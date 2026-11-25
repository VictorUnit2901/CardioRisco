import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/models/enums_avaliacao.dart';
import '../../../domain/models/fator_risco.dart';

/// Laranja usado nos ícones de alguns fatores de risco.
const Color _laranja = Color(0xFFF39C12);

/// Cor, ícone e texto de cada nível de risco nas Telas 3 e 4.
/// Fica na camada de apresentação porque é só aparência: o domínio
/// não precisa saber de cores.
extension NivelRiscoVisual on NivelRisco {
  /// Verde, amarelo ou vermelho, como no velocímetro.
  Color get cor => switch (this) {
        NivelRisco.baixo => AppTheme.primaryGreen,
        NivelRisco.intermediario => AppTheme.warningYellow,
        NivelRisco.alto => AppTheme.dangerRed,
      };

  IconData get icone => switch (this) {
        NivelRisco.baixo => Icons.check_circle_outline,
        NivelRisco.intermediario => Icons.warning_amber_rounded,
        NivelRisco.alto => Icons.error_outline,
      };

  /// Explicação do nível em linguagem simples.
  String get descricao => switch (this) {
        NivelRisco.baixo => 'A chance de ocorrer um evento cardiovascular '
            'nos próximos 10 anos é pequena.',
        NivelRisco.intermediario => 'Existe uma possibilidade moderada de '
            'ocorrência de um evento cardiovascular nos próximos 10 anos.',
        NivelRisco.alto => 'Existe uma possibilidade elevada de ocorrência '
            'de um evento cardiovascular nos próximos 10 anos.',
      };
}

/// Ícone e cor de cada fator de risco na lista da Tela 3.
extension FatorRiscoVisual on FatorRisco {
  IconData get icone => switch (this) {
        FatorRisco.pressaoElevada => Icons.monitor_heart_outlined,
        FatorRisco.colesterolAlto => Icons.water_drop_outlined,
        FatorRisco.hdlBaixo => Icons.opacity,
        FatorRisco.tabagismo => Icons.smoking_rooms,
        FatorRisco.diabetes => Icons.bloodtype_outlined,
        FatorRisco.idade => Icons.person_outline,
      };

  Color get cor => switch (this) {
        FatorRisco.pressaoElevada => AppTheme.dangerRed,
        FatorRisco.colesterolAlto => _laranja,
        FatorRisco.hdlBaixo => AppTheme.warningYellow,
        FatorRisco.tabagismo => AppTheme.dangerRed,
        FatorRisco.diabetes => _laranja,
        FatorRisco.idade => AppTheme.warningYellow,
      };
}

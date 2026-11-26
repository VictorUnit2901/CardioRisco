import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/enums_avaliacao.dart';

/// Cor de cada nível de risco, igual em todas as telas.
Color corDoNivel(NivelRisco nivel) {
  switch (nivel) {
    case NivelRisco.baixo:
      return AppTheme.primaryGreen;
    case NivelRisco.intermediario:
      return AppTheme.warningYellow;
    case NivelRisco.alto:
      return AppTheme.dangerRed;
  }
}

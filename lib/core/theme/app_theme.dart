import 'package:flutter/material.dart';

class AppTheme {
  // Paleta Dark Mode de alto contraste (uso em campo / luz solar e economia de bateria)
  static const Color background = Color(0xFF0F141A);
  static const Color surface = Color(0xFF1A222C);
  static const Color surfaceVariant = Color(0xFF24303D);
  static const Color primaryGreen = Color(0xFF2ECC71);
  static const Color warningYellow = Color(0xFFF1C40F);
  static const Color dangerRed = Color(0xFFE74C3C); 
  static const Color textPrimary = Color(0xFFF4F6F8);
  static const Color textSecondary = Color(0xFFA0AEC0);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: primaryGreen,
        surface: surface,
        error: dangerRed,
        onPrimary: Color(0xFF072112),
        onSurface: textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: surfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: surfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: const Color(0xFF072112),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
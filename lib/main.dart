import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CardioRiscoApp());
}

class CardioRiscoApp extends StatelessWidget {
  const CardioRiscoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioRisco',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthScreen(),
    );
  }
}
import 'package:cardiorisco/core/theme/app_theme.dart';
import 'package:cardiorisco/presentation/avaliacao/formulario_avaliacao_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('etapa 1 mostra os erros e não avança sem as respostas', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    // A tela de teste padrão é pequena (800x600) e a lista só monta o que
    // está perto da tela. Uma tela alta deixa o formulário inteiro visível.
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const FormularioAvaliacaoScreen(),
      ),
    );
    // Espera o controlador carregar e gerar o código do paciente.
    await tester.pumpAndSettle();

    expect(find.text('Informe algumas informações sobre você.'), findsOneWidget);
    expect(find.textContaining('P-0001'), findsOneWidget);

    await tester.tap(find.text('CONTINUAR →'));
    await tester.pumpAndSettle();

    expect(find.text('Informe a idade.'), findsOneWidget);
    expect(find.text('Informe o sexo.'), findsOneWidget);
    // Continua na etapa 1: o botão da etapa 2 não aparece.
    expect(find.text('CONTINUAR →'), findsOneWidget);
    expect(find.text('AVALIAR RISCO'), findsNothing);
  });
}

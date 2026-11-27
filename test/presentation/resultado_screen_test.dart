import 'package:cardiorisco/core/theme/app_theme.dart';
import 'package:cardiorisco/domain/models/avaliacao_model.dart';
import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/domain/services/calculadora_framingham.dart';
import 'package:cardiorisco/presentation/avaliacao/resultado_screen.dart';
import 'package:cardiorisco/presentation/avaliacao/widgets/velocimetro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Velocimetro.posicaoNoArco', () {
    test('cada faixa da SBC ocupa 1/3 do arco', () {
      expect(Velocimetro.posicaoNoArco(0, Sexo.masculino), 0);
      expect(Velocimetro.posicaoNoArco(5, Sexo.masculino), closeTo(1 / 3, 1e-9));
      expect(Velocimetro.posicaoNoArco(20, Sexo.masculino), closeTo(2 / 3, 1e-9));
      expect(Velocimetro.posicaoNoArco(10, Sexo.feminino), closeTo(2 / 3, 1e-9));
    });

    test('valores muito altos param no fim do arco', () {
      expect(Velocimetro.posicaoNoArco(80, Sexo.masculino), 1);
      expect(Velocimetro.posicaoNoArco(35, Sexo.feminino), 1);
    });
  });

  testWidgets('Tela 3 mostra o percentual, o nível e os fatores', (
    tester,
  ) async {
    // Caso do protótipo: homem, 56 anos, PAS 140, colesterol 210, HDL 45.
    final avaliacao = AvaliacaoModel(
      id: 'teste',
      codigoPaciente: 'P-0001',
      profissionalId: 'acs-teste',
      dataHora: DateTime(2026, 11, 25),
      idade: 56,
      sexo: Sexo.masculino,
      fumante: false,
      diabetico: false,
      pressaoSistolica: 140,
      usaRemedioPressao: false,
      colesterolTotal: 210,
      hdl: 45,
      atualizadoEm: DateTime(2026, 11, 25),
    );
    final calculada = avaliacao.copyWith(
      resultado: const CalculadoraFramingham().calcular(avaliacao),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: ResultadoScreen(avaliacao: calculada),
      ),
    );
    // Espera a animação do ponteiro terminar.
    await tester.pumpAndSettle();

    expect(find.text('15%'), findsOneWidget);
    expect(find.text('RISCO INTERMEDIÁRIO'), findsOneWidget);
    expect(find.text('Pressão arterial elevada'), findsOneWidget);
    expect(find.text('Colesterol acima do ideal'), findsOneWidget);
    expect(find.text('Idade'), findsOneWidget);
    // Segundo modelo: tabela de pontos da SBC (14 pontos = 18,4%).
    expect(find.textContaining('18,4%'), findsOneWidget);
  });
}

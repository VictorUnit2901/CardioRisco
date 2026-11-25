import 'package:cardiorisco/core/theme/app_theme.dart';
import 'package:cardiorisco/data/local/local_storage_service.dart';
import 'package:cardiorisco/domain/models/avaliacao_model.dart';
import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/domain/services/calculadora_framingham.dart';
import 'package:cardiorisco/presentation/avaliacao/recomendacoes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'Concluir salva na fila, apaga o rascunho, tenta enviar e fecha a tela',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final armazenamento = LocalStorageService();

    // Caso do protótipo, ainda como rascunho (avaliação nova).
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
    await armazenamento.salvarRascunho(avaliacao);

    var envios = 0;
    bool? retorno;

    // Uma tela simples abre a Tela 4, como a Tela 3 faz no app.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  retorno = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => RecomendacoesScreen(
                        avaliacao: calculada,
                        armazenamento: armazenamento,
                        enviarPendentes: () async {
                          envios++;
                        },
                      ),
                    ),
                  );
                },
                child: const Text('ABRIR'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ABRIR'));
    await tester.pumpAndSettle();

    expect(find.text('Recomendações'), findsOneWidget);
    expect(
      find.textContaining('reavaliar a pressão e o colesterol'),
      findsOneWidget,
    );

    final concluir = find.text('CONCLUIR E VOLTAR AO INÍCIO');
    await tester.ensureVisible(concluir);
    await tester.pumpAndSettle();
    await tester.tap(concluir);
    await tester.pumpAndSettle();

    expect(retorno, isTrue);
    expect(envios, 1);
    final fila = await armazenamento.obterAvaliacoesLocais();
    expect(fila, hasLength(1));
    expect(fila.single.statusSync, StatusSincronizacao.pendenteEnvio);
    expect(await armazenamento.obterRascunho(), isNull);
  });
}

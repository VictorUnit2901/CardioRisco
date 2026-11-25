import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/presentation/avaliacao/formulario_avaliacao_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preenche a etapa 1 com os dados do protótipo.
void preencherEtapa1(FormularioAvaliacaoController form) {
  form.alterarIdade('56');
  form.alterarSexo(Sexo.masculino);
  form.alterarFumante(false);
  form.alterarDiabetico(false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Cada teste começa com o "armazenamento do celular" vazio.
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('FormularioAvaliacaoController', () {
    test('avaliação nova recebe código anônimo e começa na etapa 1', () async {
      final form = FormularioAvaliacaoController();
      await form.iniciar();

      expect(form.codigoPaciente, 'P-0001');
      expect(form.etapa, 1);
      expect(form.modoEdicao, isFalse);
      form.dispose();
    });

    test('não avança para a etapa 2 com dados pessoais faltando', () async {
      final form = FormularioAvaliacaoController();
      await form.iniciar();
      form.alterarIdade('56');

      expect(form.avancar(), isFalse);
      expect(form.etapa, 1);
      expect(form.erros, contains('Informe o sexo.'));
      form.dispose();
    });

    test('preenche as 2 etapas e calcula o risco', () async {
      final form = FormularioAvaliacaoController();
      await form.iniciar();
      preencherEtapa1(form);

      expect(form.avancar(), isTrue);
      expect(form.etapa, 2);

      form.alterarPressao('140');
      form.alterarUsaRemedio(false);
      form.alterarColesterol('210');
      form.alterarHdl('45');
      final avaliacao = form.avaliar();

      expect(form.erros, isEmpty);
      expect(avaliacao?.resultado?.percentual, closeTo(15.37, 0.01));
      expect(avaliacao?.resultado?.nivel, NivelRisco.intermediario);
      form.dispose();
    });

    test('rascunho é retomado se o app fechar no meio da avaliação', () async {
      final primeiro = FormularioAvaliacaoController();
      await primeiro.iniciar();
      preencherEtapa1(primeiro);
      primeiro.avancar();
      primeiro.alterarPressao('140');
      // Fechar a tela antes do salvamento automático: salva na hora.
      primeiro.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final segundo = FormularioAvaliacaoController();
      await segundo.iniciar();

      expect(segundo.codigoPaciente, 'P-0001');
      expect(segundo.etapa, 2);
      expect(segundo.idade, 56);
      expect(segundo.sexo, Sexo.masculino);
      expect(segundo.pressaoSistolica, 140);
      expect(segundo.rascunhoSalvo, isTrue);
      segundo.dispose();
    });

    test('novaAvaliacao começa do zero com o próximo código', () async {
      final form = FormularioAvaliacaoController();
      await form.iniciar();
      preencherEtapa1(form);
      form.avancar();

      await form.novaAvaliacao();

      expect(form.codigoPaciente, 'P-0002');
      expect(form.etapa, 1);
      expect(form.idade, isNull);
      expect(form.sexo, isNull);
      form.dispose();
    });
  });
}

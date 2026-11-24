import 'package:cardiorisco/domain/models/avaliacao_model.dart';
import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/domain/models/resultado_risco.dart';
import 'package:cardiorisco/domain/services/calculadora_framingham.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cria uma avaliação completa para os testes. Os valores padrão são
/// os do protótipo: homem, 56 anos, não fuma, sem diabetes,
/// PAS 140 sem remédio, colesterol total 210 e HDL 45.
AvaliacaoModel criarAvaliacao({
  int idade = 56,
  Sexo sexo = Sexo.masculino,
  bool fumante = false,
  bool diabetico = false,
  int pressaoSistolica = 140,
  bool usaRemedioPressao = false,
  int colesterolTotal = 210,
  int hdl = 45,
}) {
  return AvaliacaoModel(
    id: 'teste',
    codigoPaciente: 'P-0001',
    profissionalId: 'acs-teste',
    dataHora: DateTime(2026, 11, 22),
    idade: idade,
    sexo: sexo,
    fumante: fumante,
    diabetico: diabetico,
    pressaoSistolica: pressaoSistolica,
    usaRemedioPressao: usaRemedioPressao,
    colesterolTotal: colesterolTotal,
    hdl: hdl,
    atualizadoEm: DateTime(2026, 11, 22),
  );
}

void main() {
  const calculadora = CalculadoraFramingham();

  group('CalculadoraFramingham', () {
    test('homem do protótipo: 15,37% e risco intermediário', () {
      final resultado = calculadora.calcular(criarAvaliacao());

      expect(resultado.percentual, closeTo(15.37, 0.01));
      expect(resultado.nivel, NivelRisco.intermediario);
      expect(resultado.percentualFormatado(), '15%');
    });

    test('mesmo paciente usando remédio para pressão: 20,62% e risco alto',
        () {
      final resultado =
          calculadora.calcular(criarAvaliacao(usaRemedioPressao: true));

      expect(resultado.percentual, closeTo(20.62, 0.01));
      expect(resultado.nivel, NivelRisco.alto);
    });

    test('mesmo paciente fumante: 27,46% e risco alto', () {
      final resultado = calculadora.calcular(criarAvaliacao(fumante: true));

      expect(resultado.percentual, closeTo(27.46, 0.01));
      expect(resultado.nivel, NivelRisco.alto);
    });

    test('mulher com os mesmos valores: 8,87% e risco intermediário', () {
      final resultado =
          calculadora.calcular(criarAvaliacao(sexo: Sexo.feminino));

      expect(resultado.percentual, closeTo(8.87, 0.01));
      expect(resultado.nivel, NivelRisco.intermediario);
    });

    test('mulher de 42 anos sem fatores de risco: 2,25% e risco baixo', () {
      final resultado = calculadora.calcular(criarAvaliacao(
        idade: 42,
        sexo: Sexo.feminino,
        pressaoSistolica: 118,
        colesterolTotal: 190,
        hdl: 55,
      ));

      expect(resultado.percentual, closeTo(2.25, 0.01));
      expect(resultado.nivel, NivelRisco.baixo);
    });

    test('avaliação incompleta não é calculada', () {
      final incompleta = AvaliacaoModel(
        id: 'teste',
        codigoPaciente: 'P-0002',
        profissionalId: 'acs-teste',
        dataHora: DateTime(2026, 11, 22),
        idade: 56,
        atualizadoEm: DateTime(2026, 11, 22),
      );

      expect(() => calculadora.calcular(incompleta), throwsArgumentError);
    });
  });

  group('ResultadoRisco.classificar (faixas da SBC)', () {
    test('homens: baixo < 5%, intermediário até 20%, alto acima de 20%', () {
      expect(ResultadoRisco.classificar(4.9, Sexo.masculino), NivelRisco.baixo);
      expect(ResultadoRisco.classificar(5.0, Sexo.masculino),
          NivelRisco.intermediario);
      expect(ResultadoRisco.classificar(20.0, Sexo.masculino),
          NivelRisco.intermediario);
      expect(ResultadoRisco.classificar(20.1, Sexo.masculino), NivelRisco.alto);
    });

    test('mulheres: baixo < 5%, intermediário até 10%, alto acima de 10%', () {
      expect(ResultadoRisco.classificar(4.9, Sexo.feminino), NivelRisco.baixo);
      expect(ResultadoRisco.classificar(10.0, Sexo.feminino),
          NivelRisco.intermediario);
      expect(ResultadoRisco.classificar(10.1, Sexo.feminino), NivelRisco.alto);
    });
  });

  group('AvaliacaoModel.validar (validações clínicas)', () {
    test('avaliação do protótipo é válida', () {
      expect(criarAvaliacao().validar(), isEmpty);
    });

    test('idade fora da faixa do escore é recusada', () {
      expect(criarAvaliacao(idade: 25).validar(), isNotEmpty);
    });

    test('HDL maior que o colesterol total é recusado', () {
      final erros = criarAvaliacao(hdl: 120, colesterolTotal: 110).validar();

      expect(erros, contains('O HDL deve ser menor que o colesterol total.'));
    });

    test('validar(etapa: 1) confere só os dados pessoais', () {
      // Etapa 1 preenchida e etapa 2 ainda vazia, como no meio do formulário.
      final avaliacao = AvaliacaoModel(
        id: 'teste',
        codigoPaciente: 'P-0001',
        profissionalId: 'acs-teste',
        dataHora: DateTime(2026, 11, 22),
        idade: 56,
        sexo: Sexo.masculino,
        fumante: false,
        diabetico: false,
        atualizadoEm: DateTime(2026, 11, 22),
      );

      expect(avaliacao.validar(etapa: 1), isEmpty);
      expect(avaliacao.validar(etapa: 2), isNotEmpty);
    });
  });
}

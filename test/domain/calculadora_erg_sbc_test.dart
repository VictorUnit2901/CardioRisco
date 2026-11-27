import 'package:cardiorisco/domain/models/avaliacao_model.dart';
import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/domain/services/calculadora_erg_sbc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Avaliação completa. Os valores padrão são os do protótipo:
/// homem, 56 anos, PAS 140 sem remédio, colesterol 210 e HDL 45.
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
    dataHora: DateTime(2026, 11, 27),
    idade: idade,
    sexo: sexo,
    fumante: fumante,
    diabetico: diabetico,
    pressaoSistolica: pressaoSistolica,
    usaRemedioPressao: usaRemedioPressao,
    colesterolTotal: colesterolTotal,
    hdl: hdl,
    atualizadoEm: DateTime(2026, 11, 27),
  );
}

void main() {
  const calculadora = CalculadoraErgSbc();

  group('CalculadoraErgSbc (tabela de pontos)', () {
    test('caso do protótipo: 14 pontos, 18,4%, intermediário', () {
      final avaliacao = criarAvaliacao();
      // Idade 55-59 = 10, HDL 45-49 = 0, CT 200-239 = 2, PAS 140-159 = 2.
      expect(calculadora.calcularPontos(avaliacao), 14);

      final resultado = calculadora.calcular(avaliacao);
      expect(resultado.percentual, 18.4);
      expect(resultado.nivel, NivelRisco.intermediario);
      expect(resultado.modelo, calculadora.nomeModelo);
    });

    test('mulher com valores baixos: 1 ponto, 1,5%, baixo', () {
      final avaliacao = criarAvaliacao(
        idade: 42,
        sexo: Sexo.feminino,
        pressaoSistolica: 118,
        colesterolTotal: 190,
        hdl: 55,
      );
      // Idade 40-44 = 4, HDL 50-59 = -1, CT 160-199 = 1, PAS <120 = -3.
      expect(calculadora.calcularPontos(avaliacao), 1);

      final resultado = calculadora.calcular(avaliacao);
      expect(resultado.percentual, 1.5);
      expect(resultado.nivel, NivelRisco.baixo);
    });

    test('fumo e diabetes somam pontos diferentes para cada sexo', () {
      final homem = criarAvaliacao(fumante: true, diabetico: true);
      final mulher = criarAvaliacao(
        sexo: Sexo.feminino,
        fumante: true,
        diabetico: true,
      );

      // Homem: 14 + fumo 4 + diabetes 3. Mulher: 13 + fumo 3 + diabetes 4.
      expect(calculadora.calcularPontos(homem), 21);
      expect(calculadora.calcularPontos(mulher), 20);
      expect(calculadora.calcular(homem).nivel, NivelRisco.alto);
    });

    test('remédio para pressão usa a coluna de PAS tratada', () {
      final semRemedio = criarAvaliacao(pressaoSistolica: 135);
      final comRemedio = criarAvaliacao(
        pressaoSistolica: 135,
        usaRemedioPressao: true,
      );

      // PAS 130-139: 1 ponto sem remédio e 3 pontos com remédio (homens).
      expect(
        calculadora.calcularPontos(comRemedio) -
            calculadora.calcularPontos(semRemedio),
        2,
      );
    });

    test('pontos fora da tabela viram <1% e >30%', () {
      expect(
        CalculadoraErgSbc.percentualPorPontos(-5, Sexo.masculino),
        lessThan(1),
      );
      expect(
        CalculadoraErgSbc.percentualPorPontos(25, Sexo.feminino),
        greaterThan(30),
      );
      expect(CalculadoraErgSbc.formatarPercentual(0.5), '<1%');
      expect(CalculadoraErgSbc.formatarPercentual(31), '>30%');
      expect(CalculadoraErgSbc.formatarPercentual(18.4), '18,4%');
    });

    test('avaliação incompleta é recusada', () {
      final incompleta = AvaliacaoModel(
        id: 'teste',
        codigoPaciente: 'P-0001',
        profissionalId: 'acs-teste',
        dataHora: DateTime(2026, 11, 27),
        atualizadoEm: DateTime(2026, 11, 27),
      );

      expect(() => calculadora.calcular(incompleta), throwsArgumentError);
    });
  });
}

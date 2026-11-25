import 'package:cardiorisco/domain/models/avaliacao_model.dart';
import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/domain/models/fator_risco.dart';
import 'package:cardiorisco/domain/services/identificador_fatores.dart';
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
    dataHora: DateTime(2026, 11, 25),
    idade: idade,
    sexo: sexo,
    fumante: fumante,
    diabetico: diabetico,
    pressaoSistolica: pressaoSistolica,
    usaRemedioPressao: usaRemedioPressao,
    colesterolTotal: colesterolTotal,
    hdl: hdl,
    atualizadoEm: DateTime(2026, 11, 25),
  );
}

void main() {
  const identificador = IdentificadorFatores();

  group('IdentificadorFatores', () {
    test('caso do protótipo: pressão, colesterol e idade', () {
      expect(identificador.identificar(criarAvaliacao()), [
        FatorRisco.pressaoElevada,
        FatorRisco.colesterolAlto,
        FatorRisco.idade,
      ]);
    });

    test('remédio para pressão, HDL baixo, fumo e diabetes aparecem', () {
      final fatores = identificador.identificar(criarAvaliacao(
        idade: 40,
        fumante: true,
        diabetico: true,
        pressaoSistolica: 120,
        usaRemedioPressao: true,
        colesterolTotal: 170,
        hdl: 35,
      ));

      expect(fatores, [
        FatorRisco.pressaoElevada,
        FatorRisco.hdlBaixo,
        FatorRisco.tabagismo,
        FatorRisco.diabetes,
      ]);
    });

    test('nenhum fator quando tudo está no recomendado', () {
      final fatores = identificador.identificar(criarAvaliacao(
        idade: 42,
        sexo: Sexo.feminino,
        pressaoSistolica: 118,
        colesterolTotal: 170,
        hdl: 55,
      ));

      expect(fatores, isEmpty);
    });

    test('idade conta a partir de 45 anos (homens) e 55 anos (mulheres)', () {
      final homem50 = identificador.identificar(criarAvaliacao(
        idade: 50,
        pressaoSistolica: 120,
        colesterolTotal: 170,
      ));
      final mulher50 = identificador.identificar(criarAvaliacao(
        idade: 50,
        sexo: Sexo.feminino,
        pressaoSistolica: 120,
        colesterolTotal: 170,
      ));

      expect(homem50, [FatorRisco.idade]);
      expect(mulher50, isEmpty);
    });
  });
}

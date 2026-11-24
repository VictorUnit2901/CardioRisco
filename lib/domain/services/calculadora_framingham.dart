import 'dart:math';

import '../models/avaliacao_model.dart';
import '../models/enums_avaliacao.dart';
import '../models/resultado_risco.dart';
import 'calculadora_risco.dart';

/// Cálculo pelo Escore de Framingham para risco cardiovascular geral
/// (D'Agostino et al., Circulation, 2008), base do Escore de Risco
/// Global da Sociedade Brasileira de Cardiologia.
///
/// Fórmula: risco = 1 - S0 ^ exp(soma - média)
/// onde "soma" é cada fator (em logaritmo, quando é uma medida)
/// multiplicado pelo seu peso.
class CalculadoraFramingham implements CalculadoraRisco {
  const CalculadoraFramingham();

  @override
  String get nomeModelo => 'Framingham (2008)';

  @override
  ResultadoRisco calcular(AvaliacaoModel avaliacao) {
    final erros = avaliacao.validar();
    if (erros.isNotEmpty) {
      throw ArgumentError('Avaliação inválida: ${erros.join(' ')}');
    }

    // Depois do validar(), sabemos que nenhum campo está vazio.
    // O "!" diz ao Dart: "pode confiar, aqui não é null".
    final sexo = avaliacao.sexo!;
    final pesos = sexo == Sexo.masculino ? _pesosHomem : _pesosMulher;

    final pesoPressao = avaliacao.usaRemedioPressao!
        ? pesos.pressaoComRemedio
        : pesos.pressaoSemRemedio;

    final soma = pesos.idade * log(avaliacao.idade!) +
        pesos.colesterolTotal * log(avaliacao.colesterolTotal!) +
        pesos.hdl * log(avaliacao.hdl!) +
        pesoPressao * log(avaliacao.pressaoSistolica!) +
        (avaliacao.fumante! ? pesos.fumante : 0.0) +
        (avaliacao.diabetico! ? pesos.diabetes : 0.0);

    final risco =
        1 - pow(pesos.sobrevidaBase, exp(soma - pesos.media)).toDouble();
    final percentual = risco * 100;

    return ResultadoRisco(
      percentual: percentual,
      nivel: ResultadoRisco.classificar(percentual, sexo),
      modelo: nomeModelo,
      calculadoEm: DateTime.now(),
    );
  }
}

/// Pesos (coeficientes) do modelo de Framingham para um sexo.
class _Pesos {
  final double idade;
  final double colesterolTotal;
  final double hdl;
  final double pressaoSemRemedio;
  final double pressaoComRemedio;
  final double fumante;
  final double diabetes;

  /// S0: fração de pessoas "típicas" do estudo sem evento em 10 anos.
  final double sobrevidaBase;

  /// Soma dos fatores de uma pessoa "típica" do estudo.
  final double media;

  const _Pesos({
    required this.idade,
    required this.colesterolTotal,
    required this.hdl,
    required this.pressaoSemRemedio,
    required this.pressaoComRemedio,
    required this.fumante,
    required this.diabetes,
    required this.sobrevidaBase,
    required this.media,
  });
}

const _pesosHomem = _Pesos(
  idade: 3.06117,
  colesterolTotal: 1.12370,
  hdl: -0.93263,
  pressaoSemRemedio: 1.93303,
  pressaoComRemedio: 1.99881,
  fumante: 0.65451,
  diabetes: 0.57367,
  sobrevidaBase: 0.88936,
  media: 23.9802,
);

const _pesosMulher = _Pesos(
  idade: 2.32888,
  colesterolTotal: 1.20904,
  hdl: -0.70833,
  pressaoSemRemedio: 2.76157,
  pressaoComRemedio: 2.82263,
  fumante: 0.52873,
  diabetes: 0.69154,
  sobrevidaBase: 0.95012,
  media: 26.1931,
);

import 'enums_avaliacao.dart';

/// Resultado do cálculo do risco cardiovascular em 10 anos.
class ResultadoRisco {
  /// Probabilidade de evento cardiovascular em 10 anos, de 0 a 100 (%).
  final double percentual;

  /// Classificação: baixo, intermediário ou alto.
  final NivelRisco nivel;

  /// Modelo usado no cálculo (ex.: Framingham).
  final String modelo;

  /// Momento em que o cálculo foi feito.
  final DateTime calculadoEm;

  const ResultadoRisco({
    required this.percentual,
    required this.nivel,
    required this.modelo,
    required this.calculadoEm,
  });

  /// Abaixo deste percentual o risco é baixo (homens e mulheres).
  static const double limiteBaixo = 5;

  /// Acima deste percentual o risco é alto: 20% para homens, 10% para mulheres.
  static double limiteAlto(Sexo sexo) => sexo == Sexo.masculino ? 20 : 10;

  /// Classifica o percentual conforme o Escore de Risco Global da SBC.
  ///
  /// Homens:   baixo < 5% | intermediário 5% a 20% | alto > 20%
  /// Mulheres: baixo < 5% | intermediário 5% a 10% | alto > 10%
  static NivelRisco classificar(double percentual, Sexo sexo) {
    if (percentual < limiteBaixo) {
      return NivelRisco.baixo;
    }
    if (percentual <= limiteAlto(sexo)) {
      return NivelRisco.intermediario;
    }
    return NivelRisco.alto;
  }

  /// Percentual arredondado para a tela (ex.: "15%").
  String percentualFormatado() => '${percentual.round()}%';
}

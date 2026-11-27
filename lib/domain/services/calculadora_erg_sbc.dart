import '../models/avaliacao_model.dart';
import '../models/enums_avaliacao.dart';
import '../models/resultado_risco.dart';
import 'calculadora_risco.dart';

/// Escore de Risco Global (ERG) da SBC pela TABELA DE PONTOS.
///
/// É a versão "de papel" do mesmo modelo de Framingham (D'Agostino e
/// colaboradores, 2008): cada resposta vale alguns pontos, a soma dos
/// pontos vira um percentual de risco em 10 anos numa segunda tabela.
/// Como os pontos arredondam a equação, o resultado pode ficar um pouco
/// diferente do da [CalculadoraFramingham].
///
/// Fonte: V Diretriz Brasileira de Dislipidemias e Prevenção da
/// Aterosclerose (SBC). Arq Bras Cardiol. 2013;101(4 Supl 1):1-22,
/// Tabelas IV a VII, baseadas em D'Agostino RB et al. Circulation.
/// 2008;117:743-753.
///
/// Observação: na linha de 2 pontos, a diretriz escreve "120-139" na
/// coluna da PAS tratada, mas a faixa 130-139 aparece de novo na linha
/// de 3 pontos. Seguimos o artigo original: 120-129 = 2 e 130-139 = 3.
class CalculadoraErgSbc implements CalculadoraRisco {
  const CalculadoraErgSbc();

  @override
  String get nomeModelo => 'ERG/SBC (tabela de pontos)';

  /// Usado no lugar de "menor que 1%" e "maior que 30%" da tabela.
  static const double menorQueUm = 0.5;
  static const double acimaDeTrinta = 31;

  @override
  ResultadoRisco calcular(AvaliacaoModel avaliacao) {
    final erros = avaliacao.validar();
    if (erros.isNotEmpty) {
      throw ArgumentError(erros.join(' '));
    }
    final sexo = avaliacao.sexo!;
    final percentual = percentualPorPontos(calcularPontos(avaliacao), sexo);
    return ResultadoRisco(
      percentual: percentual,
      nivel: ResultadoRisco.classificar(percentual, sexo),
      modelo: nomeModelo,
      calculadoEm: DateTime.now(),
    );
  }

  /// Soma os pontos de cada resposta (avaliação já validada).
  int calcularPontos(AvaliacaoModel avaliacao) {
    final homem = avaliacao.sexo == Sexo.masculino;
    final pressao = avaliacao.pressaoSistolica!;
    final comRemedio = avaliacao.usaRemedioPressao!;

    var pontos = 0;

    // Idade: 30-34, 35-39, 40-44, 45-49, 50-54, 55-59, 60-64, 65-69,
    // 70-74 e 75 ou mais.
    pontos += _porFaixa(
      avaliacao.idade!,
      const [35, 40, 45, 50, 55, 60, 65, 70, 75],
      homem
          ? const [0, 2, 5, 6, 8, 10, 11, 12, 14, 15]
          : const [0, 2, 4, 5, 7, 8, 9, 10, 11, 12],
    );

    // HDL: <35, 35-44, 45-49, 50-59 e 60 ou mais (igual para os dois sexos).
    pontos += _porFaixa(
      avaliacao.hdl!,
      const [35, 45, 50, 60],
      const [2, 1, 0, -1, -2],
    );

    // Colesterol total: <160, 160-199, 200-239, 240-279 e 280 ou mais.
    pontos += _porFaixa(
      avaliacao.colesterolTotal!,
      const [160, 200, 240, 280],
      homem ? const [0, 1, 2, 3, 4] : const [0, 1, 3, 4, 5],
    );

    // Pressão sistólica. Nos homens as faixas acima de 140 são 140-159 e
    // 160 ou mais; nas mulheres, 140-149, 150-159 e 160 ou mais.
    if (homem) {
      pontos += _porFaixa(
        pressao,
        const [120, 130, 140, 160],
        comRemedio ? const [0, 2, 3, 4, 5] : const [-2, 0, 1, 2, 3],
      );
    } else {
      pontos += _porFaixa(
        pressao,
        const [120, 130, 140, 150, 160],
        comRemedio ? const [-1, 2, 3, 5, 6, 7] : const [-3, 0, 1, 2, 4, 5],
      );
    }

    if (avaliacao.fumante!) {
      pontos += homem ? 4 : 3;
    }
    if (avaliacao.diabetico!) {
      pontos += homem ? 3 : 4;
    }
    return pontos;
  }

  /// Converte o total de pontos no risco em 10 anos (%).
  static double percentualPorPontos(int pontos, Sexo sexo) {
    if (sexo == Sexo.masculino) {
      // Homens: -3 ou menos = <1% ... 18 ou mais = >30%.
      const tabela = [
        1.1, 1.4, 1.6, 1.9, 2.3, 2.8, 3.3, 3.9, 4.7, 5.6, //
        6.7, 7.9, 9.4, 11.2, 13.2, 15.6, 18.4, 21.6, 25.3, 29.4,
      ];
      return _naTabela(pontos, primeiro: -2, tabela: tabela);
    }
    // Mulheres: -2 ou menos = <1% ... 21 ou mais = >30%.
    const tabela = [
      1.0, 1.2, 1.5, 1.7, 2.0, 2.4, 2.8, 3.3, 3.9, 4.5, 5.3, //
      6.3, 7.3, 8.6, 10.0, 11.7, 13.7, 15.9, 18.5, 21.6, 24.8, 28.5,
    ];
    return _naTabela(pontos, primeiro: -1, tabela: tabela);
  }

  /// Texto do percentual como na tabela: "<1%", "18,4%" ou ">30%".
  static String formatarPercentual(double percentual) {
    if (percentual < 1) {
      return '<1%';
    }
    if (percentual > 30) {
      return '>30%';
    }
    return '${percentual.toStringAsFixed(1).replaceAll('.', ',')}%';
  }

  static double _naTabela(
    int pontos, {
    required int primeiro,
    required List<double> tabela,
  }) {
    final indice = pontos - primeiro;
    if (indice < 0) {
      return menorQueUm;
    }
    if (indice >= tabela.length) {
      return acimaDeTrinta;
    }
    return tabela[indice];
  }

  /// [limites] são os começos das faixas a partir da segunda; [pontos] tem
  /// um item a mais que [limites] (um para cada faixa).
  static int _porFaixa(int valor, List<int> limites, List<int> pontos) {
    var faixa = 0;
    while (faixa < limites.length && valor >= limites[faixa]) {
      faixa++;
    }
    return pontos[faixa];
  }
}

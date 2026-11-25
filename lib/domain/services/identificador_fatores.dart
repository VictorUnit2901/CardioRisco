import '../models/avaliacao_model.dart';
import '../models/enums_avaliacao.dart';
import '../models/fator_risco.dart';

/// Descobre quais respostas da avaliação estão contribuindo para o risco.
///
/// Limites usados:
/// - Pressão: sistólica >= 140 mmHg (hipertensão) ou uso de remédio.
/// - Colesterol total: >= 190 mg/dL (acima do desejável).
/// - HDL: < 40 mg/dL.
/// - Idade: >= 45 anos (homens) ou >= 55 anos (mulheres).
/// - Tabagismo e diabetes: resposta "Sim".
class IdentificadorFatores {
  const IdentificadorFatores();

  static const int pressaoLimite = 140;
  static const int colesterolLimite = 190;
  static const int hdlMinimo = 40;
  static const int idadeHomem = 45;
  static const int idadeMulher = 55;

  /// Devolve os fatores na ordem em que aparecem na tela.
  /// Lista vazia quando nenhuma resposta está alterada.
  List<FatorRisco> identificar(AvaliacaoModel avaliacao) {
    final fatores = <FatorRisco>[];

    final pressao = avaliacao.pressaoSistolica;
    if ((pressao != null && pressao >= pressaoLimite) ||
        avaliacao.usaRemedioPressao == true) {
      fatores.add(FatorRisco.pressaoElevada);
    }

    final colesterol = avaliacao.colesterolTotal;
    if (colesterol != null && colesterol >= colesterolLimite) {
      fatores.add(FatorRisco.colesterolAlto);
    }

    final hdl = avaliacao.hdl;
    if (hdl != null && hdl < hdlMinimo) {
      fatores.add(FatorRisco.hdlBaixo);
    }

    if (avaliacao.fumante == true) {
      fatores.add(FatorRisco.tabagismo);
    }

    if (avaliacao.diabetico == true) {
      fatores.add(FatorRisco.diabetes);
    }

    final idade = avaliacao.idade;
    final idadeLimite =
        avaliacao.sexo == Sexo.feminino ? idadeMulher : idadeHomem;
    if (idade != null && idade >= idadeLimite) {
      fatores.add(FatorRisco.idade);
    }

    return fatores;
  }
}

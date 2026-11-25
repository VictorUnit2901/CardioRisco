import '../models/avaliacao_model.dart';
import '../models/enums_avaliacao.dart';
import '../models/fator_risco.dart';
import '../models/recomendacao.dart';
import 'identificador_fatores.dart';

/// Monta as recomendações da Tela 4 a partir do nível de risco e das
/// respostas da avaliação.
///
/// - O encaminhamento muda conforme o nível (baixo, intermediário, alto)
///   e cita os fatores que precisam ser reavaliados.
/// - "Parar de fumar" só aparece para fumantes e "Controle do diabetes"
///   só para quem tem diabetes.
/// - As demais orientações de estilo de vida valem para todos.
class GeradorRecomendacoes {
  const GeradorRecomendacoes({
    this.identificador = const IdentificadorFatores(),
  });

  final IdentificadorFatores identificador;

  /// O encaminhamento vem sempre primeiro. Devolve lista vazia se a
  /// avaliação ainda não foi calculada.
  List<Recomendacao> gerar(AvaliacaoModel avaliacao) {
    final resultado = avaliacao.resultado;
    if (resultado == null) {
      return const [];
    }
    final fatores = identificador.identificar(avaliacao);

    return [
      _encaminhamento(resultado.nivel, fatores),
      if (fatores.contains(FatorRisco.tabagismo)) _pararDeFumar,
      _atividadeFisica,
      _alimentacao,
      if (fatores.contains(FatorRisco.diabetes)) _controleDiabetes,
      _acompanhamento,
      _peso,
    ];
  }

  Recomendacao _encaminhamento(NivelRisco nivel, List<FatorRisco> fatores) {
    final (descricao, detalhe) = switch (nivel) {
      NivelRisco.baixo => (
          'manter as consultas de rotina na UBS e repetir a avaliação '
              'periodicamente.',
          'O risco está baixo e não há necessidade de encaminhamento agora. '
              'Manter os hábitos saudáveis e o acompanhamento de rotina ajuda '
              'a manter o risco assim.',
        ),
      NivelRisco.intermediario => (
          'agendar consulta de acompanhamento na UBS para reavaliar '
              '${_oQueReavaliar(fatores)}.',
          'Com risco intermediário, a equipe de saúde acompanha os fatores '
              'alterados e decide se são necessários exames ou tratamento.',
        ),
      NivelRisco.alto => (
          'encaminhar para consulta com o médico da UBS o quanto antes, '
              'levando este resultado.',
          'Com risco alto, o médico avalia a necessidade de tratamento e de '
              'exames complementares. O resultado do app não substitui essa '
              'avaliação.',
        ),
    };
    return Recomendacao(
      titulo: 'Encaminhamento sugerido',
      descricao: descricao,
      detalhe: detalhe,
      tipo: TipoRecomendacao.encaminhamento,
      tema: TemaRecomendacao.encaminhamento,
    );
  }

  /// Ex.: "a pressão e o colesterol".
  String _oQueReavaliar(List<FatorRisco> fatores) {
    final itens = [
      if (fatores.contains(FatorRisco.pressaoElevada)) 'a pressão',
      if (fatores.contains(FatorRisco.colesterolAlto) ||
          fatores.contains(FatorRisco.hdlBaixo))
        'o colesterol',
      if (fatores.contains(FatorRisco.diabetes)) 'a glicemia',
    ];
    if (itens.isEmpty) {
      return 'os fatores de risco';
    }
    if (itens.length == 1) {
      return itens.first;
    }
    final inicio = itens.sublist(0, itens.length - 1).join(', ');
    return '$inicio e ${itens.last}';
  }

  static const _pararDeFumar = Recomendacao(
    titulo: 'Parar de fumar',
    descricao: 'É a mudança que mais reduz o risco. A UBS oferece apoio '
        'gratuito para parar.',
    detalhe: 'O risco cardiovascular começa a cair logo depois de parar de '
        'fumar. O SUS oferece tratamento gratuito, com acompanhamento e, '
        'quando indicado, medicamentos. Procure a equipe da UBS.',
    tipo: TipoRecomendacao.estiloDeVida,
    tema: TemaRecomendacao.tabagismo,
  );

  static const _atividadeFisica = Recomendacao(
    titulo: 'Atividade física',
    descricao: 'Pratique pelo menos 150 minutos de atividade moderada por '
        'semana.',
    detalhe: 'Caminhada rápida, bicicleta e dança contam como atividade '
        'moderada. Dá para dividir em 30 minutos, 5 dias por semana. Quem '
        'está parado deve começar aos poucos e aumentar com o tempo.',
    tipo: TipoRecomendacao.estiloDeVida,
    tema: TemaRecomendacao.atividadeFisica,
  );

  static const _alimentacao = Recomendacao(
    titulo: 'Alimentação',
    descricao: 'Priorize alimentos naturais, reduza o sal, açúcar e gorduras '
        'saturadas.',
    detalhe: 'Prefira frutas, verduras, legumes, feijão e grãos integrais. '
        'Evite embutidos, salgadinhos, refrigerantes e frituras. Use pouco '
        'sal no preparo e não leve o saleiro à mesa.',
    tipo: TipoRecomendacao.estiloDeVida,
    tema: TemaRecomendacao.alimentacao,
  );

  static const _controleDiabetes = Recomendacao(
    titulo: 'Controle do diabetes',
    descricao: 'Siga o tratamento e acompanhe a glicemia regularmente na UBS.',
    detalhe: 'Manter a glicemia controlada protege o coração e os vasos. '
        'Tome os remédios como orientado, faça os exames de rotina e cuide '
        'dos pés.',
    tipo: TipoRecomendacao.estiloDeVida,
    tema: TemaRecomendacao.diabetes,
  );

  static const _acompanhamento = Recomendacao(
    titulo: 'Acompanhamento médico',
    descricao: 'Monitore sua pressão arterial, colesterol e glicemia '
        'regularmente.',
    detalhe: 'Leve este resultado na próxima consulta. Medir a pressão e '
        'fazer os exames de sangue com regularidade permite ajustar o '
        'cuidado a tempo. Quem usa remédio não deve parar sem orientação.',
    tipo: TipoRecomendacao.estiloDeVida,
    tema: TemaRecomendacao.acompanhamento,
  );

  static const _peso = Recomendacao(
    titulo: 'Mantenha o peso saudável',
    descricao: 'O excesso de peso eleva o risco de doenças do coração.',
    detalhe: 'Manter o peso e a medida da cintura dentro do recomendado ajuda '
        'a controlar a pressão, o colesterol e a glicemia. A equipe da UBS '
        'pode orientar sobre o peso ideal.',
    tipo: TipoRecomendacao.estiloDeVida,
    tema: TemaRecomendacao.peso,
  );
}

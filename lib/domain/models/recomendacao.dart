/// Se a recomendação é uma mudança de hábito ou um encaminhamento
/// para a equipe de saúde.
enum TipoRecomendacao { estiloDeVida, encaminhamento }

/// Assunto da recomendação. A tela usa isso para escolher o ícone e a cor.
enum TemaRecomendacao {
  encaminhamento,
  tabagismo,
  atividadeFisica,
  alimentacao,
  diabetes,
  acompanhamento,
  peso,
}

/// Uma orientação mostrada na Tela 4.
class Recomendacao {
  const Recomendacao({
    required this.titulo,
    required this.descricao,
    required this.detalhe,
    required this.tipo,
    required this.tema,
  });

  /// Ex.: "Atividade física".
  final String titulo;

  /// Frase curta mostrada no cartão.
  final String descricao;

  /// Explicação mais completa, mostrada ao tocar no cartão.
  final String detalhe;

  final TipoRecomendacao tipo;
  final TemaRecomendacao tema;
}

/// Fatores de risco que podem aparecer nas respostas do formulário.
/// São mostrados na Tela 3 ("O que influencia seu risco?") e usados
/// nas recomendações da Tela 4.
enum FatorRisco {
  pressaoElevada(
    'Pressão arterial elevada',
    'A pressão sistólica está em 140 mmHg ou mais, ou o paciente usa '
        'remédio para controlar a pressão.',
  ),
  colesterolAlto(
    'Colesterol acima do ideal',
    'O colesterol total está em 190 mg/dL ou mais. O excesso de colesterol '
        'se acumula nas artérias.',
  ),
  hdlBaixo(
    'HDL baixo',
    'O HDL, o colesterol "bom", está abaixo de 40 mg/dL. Ele ajuda a '
        'retirar o excesso de colesterol das artérias.',
  ),
  tabagismo(
    'Tabagismo',
    'Fumar danifica os vasos sanguíneos e é um dos fatores que mais '
        'aumentam o risco cardiovascular.',
  ),
  diabetes(
    'Diabetes',
    'O açúcar alto no sangue acelera o desgaste das artérias.',
  ),
  idade(
    'Idade',
    'O risco cardiovascular aumenta naturalmente com a idade: a partir '
        'dos 45 anos nos homens e dos 55 anos nas mulheres.',
  );

  const FatorRisco(this.titulo, this.explicacao);

  /// Texto curto mostrado na lista.
  final String titulo;

  /// Explicação mostrada quando o profissional toca no fator.
  final String explicacao;
}

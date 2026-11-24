/// Sexo informado na avaliação. O cálculo usa coeficientes
/// diferentes para homens e mulheres.
enum Sexo {
  masculino('Masculino'),
  feminino('Feminino');

  const Sexo(this.rotulo);

  /// Texto mostrado na tela.
  final String rotulo;
}

/// Nível de risco cardiovascular em 10 anos (Escore de Risco Global - SBC).
enum NivelRisco {
  baixo('Baixo'),
  intermediario('Intermediário'),
  alto('Alto');

  const NivelRisco(this.rotulo);

  /// Texto mostrado na tela (ex.: "Intermediário").
  final String rotulo;
}

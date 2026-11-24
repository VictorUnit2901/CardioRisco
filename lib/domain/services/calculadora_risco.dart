import '../models/avaliacao_model.dart';
import '../models/resultado_risco.dart';

/// Contrato comum dos modelos de cálculo do risco cardiovascular.
///
/// Cada modelo (Framingham, Escore de Risco Global da SBC...) implementa
/// esta interface. Assim o app pode trocar ou comparar modelos sem
/// mudar o resto do código.
abstract class CalculadoraRisco {
  /// Nome do modelo, mostrado na tela e salvo junto com o resultado.
  String get nomeModelo;

  /// Calcula o risco de evento cardiovascular em 10 anos.
  ///
  /// Lança [ArgumentError] se a avaliação estiver incompleta ou inválida.
  ResultadoRisco calcular(AvaliacaoModel avaliacao);
}

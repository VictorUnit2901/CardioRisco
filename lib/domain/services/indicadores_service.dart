import '../models/avaliacao_model.dart';
import '../models/enums_avaliacao.dart';

/// Resultado agregado de um conjunto de avaliações (dashboard e relatórios).
class Indicadores {
  const Indicadores({
    required this.totalAvaliacoes,
    required this.totalPacientes,
    required this.riscoMedio,
    required this.porNivel,
    required this.fumantes,
    required this.diabeticos,
    required this.usamRemedioPressao,
    required this.masculino,
    required this.feminino,
    required this.porFaixaEtaria,
    this.pressaoMedia,
    this.colesterolMedio,
    this.hdlMedio,
  });

  /// Avaliações concluídas dentro do período.
  final int totalAvaliacoes;

  /// Pacientes distintos. Os indicadores abaixo usam a ÚLTIMA avaliação
  /// de cada paciente, para ninguém ser contado duas vezes.
  final int totalPacientes;
  final double riscoMedio;
  final Map<NivelRisco, int> porNivel;
  final int fumantes;
  final int diabeticos;
  final int usamRemedioPressao;
  final int masculino;
  final int feminino;
  final Map<String, int> porFaixaEtaria;
  final double? pressaoMedia;
  final double? colesterolMedio;
  final double? hdlMedio;

  int nivel(NivelRisco n) => porNivel[n] ?? 0;
  int get altoRisco => nivel(NivelRisco.alto);

  static const vazio = Indicadores(
    totalAvaliacoes: 0,
    totalPacientes: 0,
    riscoMedio: 0,
    porNivel: {},
    fumantes: 0,
    diabeticos: 0,
    usamRemedioPressao: 0,
    masculino: 0,
    feminino: 0,
    porFaixaEtaria: {},
  );
}

class IndicadoresService {
  static const faixasEtarias = ['30-39', '40-49', '50-59', '60-69', '70-74'];

  /// Só as avaliações que já têm resultado calculado (descarta rascunhos).
  static List<AvaliacaoModel> concluidas(List<AvaliacaoModel> todas) =>
      todas.where((a) => a.resultado != null).toList();

  /// A avaliação mais recente de cada código de paciente.
  static List<AvaliacaoModel> ultimaPorPaciente(List<AvaliacaoModel> lista) {
    final mapa = <String, AvaliacaoModel>{};
    for (final a in lista) {
      final atual = mapa[a.codigoPaciente];
      if (atual == null || a.dataHora.isAfter(atual.dataHora)) {
        mapa[a.codigoPaciente] = a;
      }
    }
    return mapa.values.toList();
  }

  /// Mantém só as avaliações dos últimos [dias] dias (null = todo o período).
  static List<AvaliacaoModel> filtrarPeriodo(
    List<AvaliacaoModel> lista,
    int? dias, {
    DateTime? agora,
  }) {
    if (dias == null) return lista;
    final limite = (agora ?? DateTime.now()).subtract(Duration(days: dias));
    return lista.where((a) => a.dataHora.isAfter(limite)).toList();
  }

  static String faixaEtaria(int idade) {
    if (idade < 40) return '30-39';
    if (idade < 50) return '40-49';
    if (idade < 60) return '50-59';
    if (idade < 70) return '60-69';
    return '70-74';
  }

  static Indicadores calcular(
    List<AvaliacaoModel> todas, {
    int? ultimosDias,
    DateTime? agora,
  }) {
    final noPeriodo =
        filtrarPeriodo(concluidas(todas), ultimosDias, agora: agora);
    if (noPeriodo.isEmpty) return Indicadores.vazio;

    final pacientes = ultimaPorPaciente(noPeriodo);
    final porNivel = <NivelRisco, int>{};
    final porFaixa = {for (final f in faixasEtarias) f: 0};
    var fumantes = 0, diabeticos = 0, remedio = 0, homens = 0, mulheres = 0;
    var somaRisco = 0.0;
    final pas = <int>[], col = <int>[], hdl = <int>[];

    for (final a in pacientes) {
      final r = a.resultado!;
      somaRisco += r.percentual;
      porNivel[r.nivel] = (porNivel[r.nivel] ?? 0) + 1;
      if (a.fumante == true) fumantes++;
      if (a.diabetico == true) diabeticos++;
      if (a.usaRemedioPressao == true) remedio++;
      if (a.sexo == Sexo.masculino) homens++;
      if (a.sexo == Sexo.feminino) mulheres++;
      if (a.idade != null) {
        final f = faixaEtaria(a.idade!);
        porFaixa[f] = (porFaixa[f] ?? 0) + 1;
      }
      if (a.pressaoSistolica != null) pas.add(a.pressaoSistolica!);
      if (a.colesterolTotal != null) col.add(a.colesterolTotal!);
      if (a.hdl != null) hdl.add(a.hdl!);
    }

    double? media(List<int> v) =>
        v.isEmpty ? null : v.reduce((x, y) => x + y) / v.length;

    return Indicadores(
      totalAvaliacoes: noPeriodo.length,
      totalPacientes: pacientes.length,
      riscoMedio: somaRisco / pacientes.length,
      porNivel: porNivel,
      fumantes: fumantes,
      diabeticos: diabeticos,
      usamRemedioPressao: remedio,
      masculino: homens,
      feminino: mulheres,
      porFaixaEtaria: porFaixa,
      pressaoMedia: media(pas),
      colesterolMedio: media(col),
      hdlMedio: media(hdl),
    );
  }
}

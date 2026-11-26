/// Funções pequenas de formatação usadas pelas telas e pelo PDF.
String _dois(int n) => n.toString().padLeft(2, '0');

String formatarData(DateTime d) => '${_dois(d.day)}/${_dois(d.month)}/${d.year}';

String formatarDataHora(DateTime d) =>
    '${formatarData(d)} às ${_dois(d.hour)}:${_dois(d.minute)}';

/// "12/03" — usado no eixo do gráfico de evolução.
String formatarDiaMes(DateTime d) => '${_dois(d.day)}/${_dois(d.month)}';

String simNao(bool? v) => v == null ? 'Não informado' : (v ? 'Sim' : 'Não');

/// 12.34 -> "12,3%" (vírgula decimal, padrão brasileiro).
String formatarPercentual(double v) =>
    '${v.toStringAsFixed(1).replaceAll('.', ',')}%';

/// Parte de um total, já como texto: (3, 12) -> "25,0%".
String proporcao(int parte, int total) =>
    total == 0 ? '0,0%' : formatarPercentual(parte / total * 100);

/// 12.34 -> "12,3" (sem o símbolo de %), para variações em p.p.
String formatarNumero(double v, {int casas = 1}) =>
    v.toStringAsFixed(casas).replaceAll('.', ',');

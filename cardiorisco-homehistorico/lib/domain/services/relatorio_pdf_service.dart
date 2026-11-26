import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/utils/formatadores.dart';
import '../models/avaliacao_model.dart';
import '../models/enums_avaliacao.dart';
import '../models/profissional_model.dart';
import 'indicadores_service.dart';

/// Monta os PDFs do app. Só devolve os bytes: mostrar, compartilhar ou
/// imprimir é responsabilidade da tela.
class RelatorioPdfService {
  static const _verde = PdfColor.fromInt(0xFF2ECC71);
  static const _amarelo = PdfColor.fromInt(0xFFF1C40F);
  static const _vermelho = PdfColor.fromInt(0xFFE74C3C);
  static const _cinza = PdfColor.fromInt(0xFF666666);

  static const _avisoClinico =
      'Este documento apoia o acompanhamento e não substitui a avaliação '
      'clínica. O risco é uma estimativa de eventos cardiovasculares em 10 anos.';

  static PdfColor _cor(NivelRisco n) {
    switch (n) {
      case NivelRisco.baixo:
        return _verde;
      case NivelRisco.intermediario:
        return _amarelo;
      case NivelRisco.alto:
        return _vermelho;
    }
  }

  static pw.Widget _cabecalho(String titulo, List<String> linhas) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('CardioRisco',
            style: pw.TextStyle(
                fontSize: 11, color: _cinza, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text(titulo,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        for (final l in linhas)
          pw.Text(l, style: const pw.TextStyle(fontSize: 10, color: _cinza)),
        pw.Divider(),
      ],
    );
  }

  static pw.Widget _tabela(List<List<String>> linhas) {
    return pw.TableHelper.fromTextArray(
      data: linhas,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _barra(String rotulo, int valor, int total, PdfColor cor) {
    const larguraMax = 260.0;
    final fracao = total == 0 ? 0.0 : valor / total;
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(children: [
        pw.SizedBox(
            width: 95,
            child: pw.Text(rotulo, style: const pw.TextStyle(fontSize: 10))),
        pw.Container(width: larguraMax, height: 10, color: PdfColors.grey200,
            alignment: pw.Alignment.centerLeft,
            child: pw.Container(width: larguraMax * fracao, height: 10, color: cor)),
        pw.SizedBox(width: 8),
        pw.Text('$valor (${proporcao(valor, total)})',
            style: const pw.TextStyle(fontSize: 10)),
      ]),
    );
  }

  static pw.Widget _titulo(String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
        child: pw.Text(t,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
      );

  /// Relatório epidemiológico agregado (sem códigos de pacientes).
  static Future<Uint8List> agregado({
    required Indicadores ind,
    required String periodo,
    ProfissionalModel? profissional,
    DateTime? agora,
  }) async {
    final doc = pw.Document(title: 'Relatório epidemiológico - CardioRisco');
    final n = ind.totalPacientes;
    final r = ind.riscoMedio;

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      footer: (ctx) => pw.Text('Página ${ctx.pageNumber} de ${ctx.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: _cinza)),
      build: (ctx) => [
        _cabecalho('Relatório epidemiológico', [
          'Período: $periodo',
          if (profissional != null && profissional.ubs.isNotEmpty)
            'UBS: ${profissional.ubs}',
          'Gerado em ${formatarDataHora(agora ?? DateTime.now())}',
        ]),
        _titulo('Resumo'),
        _tabela([
          ['Indicador', 'Resultado'],
          ['Avaliações concluídas no período', '${ind.totalAvaliacoes}'],
          ['Pacientes avaliados', '$n'],
          ['Risco médio em 10 anos', formatarPercentual(r)],
          if (ind.pressaoMedia != null)
            ['Pressão sistólica média',
              '${formatarNumero(ind.pressaoMedia!, casas: 0)} mmHg'],
          if (ind.colesterolMedio != null)
            ['Colesterol total médio',
              '${formatarNumero(ind.colesterolMedio!, casas: 0)} mg/dL'],
          if (ind.hdlMedio != null)
            ['HDL médio', '${formatarNumero(ind.hdlMedio!, casas: 0)} mg/dL'],
        ]),
        _titulo('Classificação de risco'),
        for (final nivel in NivelRisco.values)
          _barra(nivel.rotulo, ind.nivel(nivel), n, _cor(nivel)),
        _titulo('Fatores de risco'),
        _barra('Fumantes', ind.fumantes, n, _vermelho),
        _barra('Diabetes', ind.diabeticos, n, _vermelho),
        _barra('Remédio p/ pressão', ind.usamRemedioPressao, n, _amarelo),
        _titulo('Perfil dos pacientes'),
        _tabela([
          ['Sexo', 'Pacientes', '%'],
          ['Masculino', '${ind.masculino}', proporcao(ind.masculino, n)],
          ['Feminino', '${ind.feminino}', proporcao(ind.feminino, n)],
        ]),
        pw.SizedBox(height: 10),
        _tabela([
          ['Faixa etária', 'Pacientes', '%'],
          for (final f in IndicadoresService.faixasEtarias)
            [f, '${ind.porFaixaEtaria[f] ?? 0}',
              proporcao(ind.porFaixaEtaria[f] ?? 0, n)],
        ]),
        pw.SizedBox(height: 16),
        pw.Text(
          'Indicadores calculados com a última avaliação de cada paciente. '
          'Dados agregados e anonimizados: não há nome nem CPF.',
          style: const pw.TextStyle(fontSize: 9, color: _cinza),
        ),
        pw.SizedBox(height: 4),
        pw.Text(_avisoClinico,
            style: const pw.TextStyle(fontSize: 9, color: _cinza)),
      ],
    ));
    return doc.save();
  }

  /// Relatório de uma avaliação (para o prontuário/visita).
  static Future<Uint8List> individual({
    required AvaliacaoModel avaliacao,
    ProfissionalModel? profissional,
    DateTime? agora,
  }) async {
    final a = avaliacao;
    final res = a.resultado;
    final doc = pw.Document(title: 'Avaliação ${a.codigoPaciente}');

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      build: (ctx) => [
        _cabecalho('Avaliação de risco cardiovascular', [
          'Paciente: ${a.codigoPaciente}',
          'Avaliação feita em ${formatarDataHora(a.dataHora)}',
          if (profissional != null) 'Profissional: ${profissional.nome}',
          'Gerado em ${formatarDataHora(agora ?? DateTime.now())}',
        ]),
        if (res != null) ...[
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _cor(res.nivel), width: 2),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Risco em 10 anos: ${formatarPercentual(res.percentual)}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text('Risco ${res.nivel.rotulo.toLowerCase()}',
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: _cor(res.nivel))),
              ],
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text('Modelo de cálculo: ${res.modelo}',
              style: const pw.TextStyle(fontSize: 9, color: _cinza)),
        ],
        _titulo('Dados informados'),
        _tabela([
          ['Dado', 'Valor'],
          ['Idade', a.idade == null ? '-' : '${a.idade} anos'],
          ['Sexo', a.sexo?.rotulo ?? '-'],
          ['Fuma atualmente', simNao(a.fumante)],
          ['Diabetes', simNao(a.diabetico)],
          ['Pressão sistólica',
            a.pressaoSistolica == null ? '-' : '${a.pressaoSistolica} mmHg'],
          ['Usa remédio para pressão', simNao(a.usaRemedioPressao)],
          ['Colesterol total',
            a.colesterolTotal == null ? '-' : '${a.colesterolTotal} mg/dL'],
          ['HDL', a.hdl == null ? '-' : '${a.hdl} mg/dL'],
        ]),
        pw.SizedBox(height: 16),
        pw.Text(_avisoClinico,
            style: const pw.TextStyle(fontSize: 9, color: _cinza)),
      ],
    ));
    return doc.save();
  }
}

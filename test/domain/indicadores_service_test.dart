import 'package:cardiorisco/domain/models/avaliacao_model.dart';
import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/domain/models/resultado_risco.dart';
import 'package:cardiorisco/domain/services/indicadores_service.dart';
import 'package:cardiorisco/domain/services/relatorio_pdf_service.dart';
import 'package:flutter_test/flutter_test.dart';

AvaliacaoModel _av(
  String codigo,
  DateTime data,
  double percentual, {
  Sexo sexo = Sexo.masculino,
  int idade = 55,
  bool fumante = false,
  bool diabetico = false,
  bool comResultado = true,
}) {
  return AvaliacaoModel(
    id: '$codigo-${data.toIso8601String()}',
    codigoPaciente: codigo,
    profissionalId: 'u1',
    dataHora: data,
    atualizadoEm: data,
    idade: idade,
    sexo: sexo,
    fumante: fumante,
    diabetico: diabetico,
    pressaoSistolica: 130,
    usaRemedioPressao: false,
    colesterolTotal: 200,
    hdl: 50,
    resultado: comResultado
        ? ResultadoRisco(
            percentual: percentual,
            nivel: ResultadoRisco.classificar(percentual, sexo),
            modelo: 'Framingham',
            calculadoEm: data,
          )
        : null,
  );
}

void main() {
  final hoje = DateTime(2026, 11, 24);

  group('IndicadoresService', () {
    test('lista vazia devolve indicadores zerados', () {
      final ind = IndicadoresService.calcular([]);
      expect(ind.totalPacientes, 0);
      expect(ind.riscoMedio, 0);
    });

    test('ignora rascunhos (sem resultado)', () {
      final ind = IndicadoresService.calcular([
        _av('P-0001', hoje, 4),
        _av('P-0002', hoje, 0, comResultado: false),
      ]);
      expect(ind.totalAvaliacoes, 1);
    });

    test('conta cada paciente uma vez, pela avaliação mais recente', () {
      final ind = IndicadoresService.calcular([
        _av('P-0001', DateTime(2026, 1, 10), 25, fumante: true),
        _av('P-0001', DateTime(2026, 9, 10), 4, fumante: false),
        _av('P-0002', DateTime(2026, 9, 11), 8),
      ]);
      expect(ind.totalAvaliacoes, 3);
      expect(ind.totalPacientes, 2);
      // A avaliação antiga (25%, fumante) não entra nos indicadores.
      expect(ind.fumantes, 0);
      expect(ind.altoRisco, 0);
      expect(ind.riscoMedio, closeTo(6, 0.001));
    });

    test('classifica por nível e por sexo', () {
      final ind = IndicadoresService.calcular([
        _av('P-0001', hoje, 3),
        _av('P-0002', hoje, 12),
        _av('P-0003', hoje, 12, sexo: Sexo.feminino), // mulher: >10% = alto
      ]);
      expect(ind.nivel(NivelRisco.baixo), 1);
      expect(ind.nivel(NivelRisco.intermediario), 1);
      expect(ind.nivel(NivelRisco.alto), 1);
      expect(ind.masculino, 2);
      expect(ind.feminino, 1);
    });

    test('filtra por período', () {
      final lista = [
        _av('P-0001', hoje.subtract(const Duration(days: 10)), 5),
        _av('P-0002', hoje.subtract(const Duration(days: 60)), 5),
      ];
      final em30 =
          IndicadoresService.calcular(lista, ultimosDias: 30, agora: hoje);
      final em90 =
          IndicadoresService.calcular(lista, ultimosDias: 90, agora: hoje);
      expect(em30.totalPacientes, 1);
      expect(em90.totalPacientes, 2);
    });

    test('agrupa por faixa etária', () {
      expect(IndicadoresService.faixaEtaria(30), '30-39');
      expect(IndicadoresService.faixaEtaria(49), '40-49');
      expect(IndicadoresService.faixaEtaria(60), '60-69');
      expect(IndicadoresService.faixaEtaria(74), '70-74');
    });
  });

  group('RelatorioPdfService', () {
    test('gera PDF agregado válido, mesmo sem dados', () async {
      final bytes = await RelatorioPdfService.agregado(
        ind: IndicadoresService.calcular([_av('P-0001', hoje, 6)]),
        periodo: 'Todo o período',
        agora: hoje,
      );
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('gera PDF individual', () async {
      final bytes = await RelatorioPdfService.individual(
        avaliacao: _av('P-0001', hoje, 6),
        agora: hoje,
      );
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });
  });
}

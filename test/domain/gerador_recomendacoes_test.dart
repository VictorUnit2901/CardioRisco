import 'package:cardiorisco/domain/models/avaliacao_model.dart';
import 'package:cardiorisco/domain/models/enums_avaliacao.dart';
import 'package:cardiorisco/domain/models/recomendacao.dart';
import 'package:cardiorisco/domain/services/calculadora_framingham.dart';
import 'package:cardiorisco/domain/services/gerador_recomendacoes.dart';
import 'package:flutter_test/flutter_test.dart';

/// Cria uma avaliação já calculada. Os valores padrão são os do
/// protótipo: homem, 56 anos, PAS 140 sem remédio, colesterol 210 e
/// HDL 45 (risco intermediário, 15%).
AvaliacaoModel criarCalculada({
  int idade = 56,
  Sexo sexo = Sexo.masculino,
  bool fumante = false,
  bool diabetico = false,
  int pressaoSistolica = 140,
  int colesterolTotal = 210,
  int hdl = 45,
}) {
  final avaliacao = AvaliacaoModel(
    id: 'teste',
    codigoPaciente: 'P-0001',
    profissionalId: 'acs-teste',
    dataHora: DateTime(2026, 11, 25),
    idade: idade,
    sexo: sexo,
    fumante: fumante,
    diabetico: diabetico,
    pressaoSistolica: pressaoSistolica,
    usaRemedioPressao: false,
    colesterolTotal: colesterolTotal,
    hdl: hdl,
    atualizadoEm: DateTime(2026, 11, 25),
  );
  return avaliacao.copyWith(
    resultado: const CalculadoraFramingham().calcular(avaliacao),
  );
}

Recomendacao encaminhamentoDe(List<Recomendacao> lista) =>
    lista.firstWhere((r) => r.tipo == TipoRecomendacao.encaminhamento);

List<String> titulosEstiloDeVida(List<Recomendacao> lista) => lista
    .where((r) => r.tipo == TipoRecomendacao.estiloDeVida)
    .map((r) => r.titulo)
    .toList();

void main() {
  const gerador = GeradorRecomendacoes();

  group('GeradorRecomendacoes', () {
    test('caso do protótipo: encaminhamento cita pressão e colesterol', () {
      final lista = gerador.gerar(criarCalculada());

      expect(lista.first.tipo, TipoRecomendacao.encaminhamento);
      expect(
        encaminhamentoDe(lista).descricao,
        contains('reavaliar a pressão e o colesterol'),
      );
      expect(titulosEstiloDeVida(lista), [
        'Atividade física',
        'Alimentação',
        'Acompanhamento médico',
        'Mantenha o peso saudável',
      ]);
    });

    test('fumante recebe "Parar de fumar" primeiro e, com risco alto, '
        'encaminhamento ao médico', () {
      final lista = gerador.gerar(criarCalculada(fumante: true));

      expect(titulosEstiloDeVida(lista).first, 'Parar de fumar');
      expect(encaminhamentoDe(lista).descricao, contains('médico'));
    });

    test('diabético recebe "Controle do diabetes"', () {
      final lista = gerador.gerar(criarCalculada(diabetico: true));

      expect(titulosEstiloDeVida(lista), contains('Controle do diabetes'));
    });

    test('risco baixo: consultas de rotina e nada de recomendações extras', () {
      final lista = gerador.gerar(criarCalculada(
        idade: 42,
        sexo: Sexo.feminino,
        pressaoSistolica: 118,
        colesterolTotal: 180,
        hdl: 55,
      ));

      expect(encaminhamentoDe(lista).descricao, contains('rotina'));
      expect(titulosEstiloDeVida(lista), isNot(contains('Parar de fumar')));
      expect(
        titulosEstiloDeVida(lista),
        isNot(contains('Controle do diabetes')),
      );
    });

    test('avaliação sem resultado não gera recomendações', () {
      final semResultado = AvaliacaoModel(
        id: 'teste',
        codigoPaciente: 'P-0001',
        profissionalId: 'acs-teste',
        dataHora: DateTime(2026, 11, 25),
        atualizadoEm: DateTime(2026, 11, 25),
      );

      expect(gerador.gerar(semResultado), isEmpty);
    });
  });
}

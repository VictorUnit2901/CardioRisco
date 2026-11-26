import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../domain/models/avaliacao_model.dart';
import '../shared/avaliacoes_loader.dart';
import '../shared/cores_risco.dart';
import '../shared/widgets_comuns.dart';

/// Compara duas avaliações do MESMO paciente, campo a campo.
class ComparacaoScreen extends StatefulWidget {
  const ComparacaoScreen({super.key});

  @override
  State<ComparacaoScreen> createState() => _ComparacaoScreenState();
}

class _ComparacaoScreenState extends State<ComparacaoScreen> {
  String? _codigo;
  String? _idA; // referência (mais antiga)
  String? _idB; // para comparar (mais recente)

  /// Escolhe um paciente e já deixa a mais antiga e a mais recente marcadas.
  void _escolherPaciente(String codigo, List<AvaliacaoModel> doPaciente) {
    final ordenadas = [...doPaciente]
      ..sort((a, b) => a.dataHora.compareTo(b.dataHora));
    setState(() {
      _codigo = codigo;
      _idA = ordenadas.first.id;
      _idB = ordenadas.last.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comparar avaliações')),
      body: AvaliacoesLoader(
        apenasConcluidas: true,
        builder: (context, todas, _) {
          // Só aparecem pacientes com pelo menos duas avaliações.
          final porPaciente = <String, List<AvaliacaoModel>>{};
          for (final a in todas) {
            porPaciente.putIfAbsent(a.codigoPaciente, () => []).add(a);
          }
          porPaciente.removeWhere((_, v) => v.length < 2);

          if (porPaciente.isEmpty) {
            return const EstadoVazio(
              'Para comparar, o mesmo paciente precisa ter pelo menos duas avaliações concluídas.',
              icone: Icons.compare_arrows,
            );
          }

          final codigos = porPaciente.keys.toList()..sort();
          final codigo = porPaciente.containsKey(_codigo) ? _codigo! : null;
          final opcoes = codigo == null
              ? <AvaliacaoModel>[]
              : (porPaciente[codigo]!
                ..sort((a, b) => a.dataHora.compareTo(b.dataHora)));
          AvaliacaoModel? achar(String? id) =>
              opcoes.where((x) => x.id == id).firstOrNull;
          final a = achar(_idA);
          final b = achar(_idB);

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              DropdownButtonFormField<String>(
                key: ValueKey('paciente-$codigo'),
                initialValue: codigo,
                decoration: const InputDecoration(labelText: 'Paciente'),
                items: [
                  for (final c in codigos)
                    DropdownMenuItem(
                        value: c,
                        child: Text('$c (${porPaciente[c]!.length} avaliações)')),
                ],
                onChanged: (v) {
                  if (v != null) _escolherPaciente(v, porPaciente[v]!);
                },
              ),
              if (codigo != null) ...[
                const SizedBox(height: 12),
                _seletor('Avaliação de referência (mais antiga)', opcoes, _idA,
                    (v) => setState(() => _idA = v)),
                const SizedBox(height: 12),
                _seletor('Avaliação para comparar (mais recente)', opcoes, _idB,
                    (v) => setState(() => _idB = v)),
              ],
              if (a != null && b != null) ...[
                const SizedBox(height: 20),
                if (a.id == b.id)
                  const Text('Escolha duas avaliações diferentes.',
                      style: TextStyle(color: AppTheme.warningYellow))
                else
                  _Resultado(a: a, b: b),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _seletor(String rotulo, List<AvaliacaoModel> opcoes, String? valor,
      ValueChanged<String?> mudou) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$rotulo-$valor'),
      initialValue: valor,
      isExpanded: true,
      decoration: InputDecoration(labelText: rotulo),
      items: [
        for (final o in opcoes)
          DropdownMenuItem(
            value: o.id,
            child: Text(
                '${formatarData(o.dataHora)} • ${formatarPercentual(o.resultado!.percentual)}'),
          ),
      ],
      onChanged: mudou,
    );
  }
}

class _Resultado extends StatelessWidget {
  const _Resultado({required this.a, required this.b});
  final AvaliacaoModel a; // antiga
  final AvaliacaoModel b; // nova

  @override
  Widget build(BuildContext context) {
    // Garante a ordem certa mesmo que a pessoa tenha invertido os campos.
    final antiga = a.dataHora.isAfter(b.dataHora) ? b : a;
    final nova = identical(antiga, a) ? b : a;
    final ra = antiga.resultado!;
    final rb = nova.resultado!;
    final variacao = rb.percentual - ra.percentual;

    final String resumo;
    final Color corResumo;
    if (variacao.abs() < 0.05) {
      resumo = 'O risco ficou estável.';
      corResumo = AppTheme.textSecondary;
    } else if (variacao < 0) {
      resumo = 'O risco diminuiu ${formatarNumero(variacao.abs())} ponto(s) percentual(is).';
      corResumo = AppTheme.primaryGreen;
    } else {
      resumo = 'O risco aumentou ${formatarNumero(variacao)} ponto(s) percentual(is).';
      corResumo = AppTheme.dangerRed;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetricGrid(itens: [
          Metrica('Antes (${formatarData(antiga.dataHora)})',
              formatarPercentual(ra.percentual), Icons.calendar_today,
              cor: corDoNivel(ra.nivel)),
          Metrica('Depois (${formatarData(nova.dataHora)})',
              formatarPercentual(rb.percentual), Icons.trending_up,
              cor: corDoNivel(rb.nivel)),
          Metrica('Variação',
              '${variacao > 0 ? '+' : ''}${formatarNumero(variacao)} p.p.',
              Icons.compare_arrows, cor: corResumo),
        ]),
        const SizedBox(height: 10),
        Text(resumo,
            style: TextStyle(color: corResumo, fontWeight: FontWeight.bold)),
        if (ra.nivel != rb.nivel)
          Text('Classificação: ${ra.nivel.rotulo} → ${rb.nivel.rotulo}'),
        const SizedBox(height: 18),
        const TituloSecao('O que mudou'),
        _linha('Pressão sistólica', antiga.pressaoSistolica,
            nova.pressaoSistolica, 'mmHg', menorEhMelhor: true),
        _linha('Colesterol total', antiga.colesterolTotal,
            nova.colesterolTotal, 'mg/dL', menorEhMelhor: true),
        _linha('HDL', antiga.hdl, nova.hdl, 'mg/dL', menorEhMelhor: false),
        _linhaSimNao('Fuma atualmente', antiga.fumante, nova.fumante),
        _linhaSimNao('Diabetes', antiga.diabetico, nova.diabetico),
        _linhaSimNao('Remédio para pressão', antiga.usaRemedioPressao,
            nova.usaRemedioPressao),
      ],
    );
  }

  Widget _linha(String rotulo, int? antes, int? depois, String unidade,
      {required bool menorEhMelhor}) {
    Color cor = AppTheme.textSecondary;
    String delta = 'sem mudança';
    if (antes != null && depois != null && antes != depois) {
      final d = depois - antes;
      delta = '${d > 0 ? '+' : ''}$d $unidade';
      final melhorou = menorEhMelhor ? d < 0 : d > 0;
      cor = melhorou ? AppTheme.primaryGreen : AppTheme.dangerRed;
    }
    return Card(
      child: ListTile(
        dense: true,
        title: Text(rotulo),
        subtitle: Text('${antes ?? '-'} → ${depois ?? '-'} $unidade'),
        trailing: Text(delta,
            style: TextStyle(color: cor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _linhaSimNao(String rotulo, bool? antes, bool? depois) {
    final mudou = antes != depois;
    return Card(
      child: ListTile(
        dense: true,
        title: Text(rotulo),
        subtitle: Text('${simNao(antes)} → ${simNao(depois)}'),
        trailing: Text(mudou ? 'mudou' : 'sem mudança',
            style: TextStyle(
                color: mudou ? AppTheme.warningYellow : AppTheme.textSecondary,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

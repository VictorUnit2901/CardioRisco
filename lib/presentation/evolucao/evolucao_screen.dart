import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../../domain/models/resultado_risco.dart';
import '../shared/avaliacoes_loader.dart';
import '../shared/cores_risco.dart';
import '../shared/grafico_evolucao.dart';
import '../shared/widgets_comuns.dart';

/// Gráfico do risco de um paciente ao longo das avaliações.
class EvolucaoScreen extends StatefulWidget {
  const EvolucaoScreen({super.key});

  @override
  State<EvolucaoScreen> createState() => _EvolucaoScreenState();
}

class _EvolucaoScreenState extends State<EvolucaoScreen> {
  String? _codigo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evolução do risco')),
      body: AvaliacoesLoader(
        apenasConcluidas: true,
        builder: (context, todas, _) {
          if (todas.isEmpty) {
            return const EstadoVazio('Sem avaliações concluídas para exibir.',
                icone: Icons.show_chart);
          }

          // Pacientes com mais avaliações aparecem primeiro: são os que
          // têm evolução para mostrar.
          final contagem = <String, int>{};
          for (final a in todas) {
            contagem[a.codigoPaciente] = (contagem[a.codigoPaciente] ?? 0) + 1;
          }
          final codigos = contagem.keys.toList()
            ..sort((x, y) {
              final c = contagem[y]!.compareTo(contagem[x]!);
              return c != 0 ? c : x.compareTo(y);
            });
          final selecionado =
              contagem.containsKey(_codigo) ? _codigo! : codigos.first;

          final dados = todas
              .where((a) => a.codigoPaciente == selecionado)
              .toList()
            ..sort((a, b) => a.dataHora.compareTo(b.dataHora));
          final ultima = dados.last;
          // O limite de "alto risco" depende do sexo (20% homem, 10% mulher).
          final limiteAlto =
              ResultadoRisco.limiteAlto(ultima.sexo ?? Sexo.masculino);
          final pontos = [
            for (final a in dados)
              PontoEvolucao(a.dataHora, a.resultado!.percentual,
                  a.resultado!.nivel),
          ];

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              DropdownButtonFormField<String>(
                key: ValueKey('evolucao-$selecionado'),
                initialValue: selecionado,
                decoration: const InputDecoration(labelText: 'Paciente'),
                items: [
                  for (final c in codigos)
                    DropdownMenuItem(
                        value: c,
                        child: Text('$c (${contagem[c]} avaliações)')),
                ],
                onChanged: (v) => setState(() => _codigo = v),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: GraficoEvolucao(
                      pontos: pontos, limiteAlto: limiteAlto),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Faixas: baixo < ${ResultadoRisco.limiteBaixo.round()}% • intermediário até ${limiteAlto.round()}% • alto acima de ${limiteAlto.round()}% '
                '(${ultima.sexo?.rotulo.toLowerCase() ?? 'sexo não informado'}).',
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary),
              ),
              if (dados.length == 1)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Este paciente tem só uma avaliação. A linha de evolução aparece a partir da segunda.',
                    style: TextStyle(color: AppTheme.warningYellow),
                  ),
                ),
              const SizedBox(height: 16),
              const TituloSecao('Avaliações'),
              for (final a in dados.reversed) _linha(a),
            ],
          );
        },
      ),
    );
  }

  Widget _linha(AvaliacaoModel a) {
    final r = a.resultado!;
    return Card(
      child: ListTile(
        dense: true,
        leading: Icon(Icons.circle, size: 14, color: corDoNivel(r.nivel)),
        title: Text(formatarData(a.dataHora)),
        trailing: Text(
            '${formatarPercentual(r.percentual)} • ${r.nivel.rotulo}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

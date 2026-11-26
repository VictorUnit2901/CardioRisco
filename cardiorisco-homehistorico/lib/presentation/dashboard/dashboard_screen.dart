import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../../domain/services/indicadores_service.dart';
import '../historico/detalhe_avaliacao_screen.dart';
import '../shared/avaliacoes_loader.dart';
import '../shared/cores_risco.dart';
import '../shared/grafico_rosca.dart';
import '../shared/widgets_comuns.dart';

/// Painel do ACS: indicadores dos pacientes acompanhados, com gráficos
/// de rosca e a lista de quem precisa de atenção (alto risco).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard do ACS')),
      body: AvaliacoesLoader(
        apenasConcluidas: true,
        builder: (context, todas, recarregar) {
          final ind = IndicadoresService.calcular(todas);
          if (ind.totalPacientes == 0) {
            return const EstadoVazio(
              'O painel aparece depois da primeira avaliação concluída.',
              icone: Icons.donut_large,
            );
          }
          final n = ind.totalPacientes;
          final ultimas = IndicadoresService.ultimaPorPaciente(todas);
          final altoRisco = ultimas
              .where((a) => a.resultado!.nivel == NivelRisco.alto)
              .toList()
            ..sort((a, b) =>
                b.resultado!.percentual.compareTo(a.resultado!.percentual));

          return RefreshIndicator(
            onRefresh: recarregar,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                MetricGrid(itens: [
                  Metrica('Pacientes', '$n', Icons.people_outline),
                  Metrica('Alto risco', '${ind.altoRisco}',
                      Icons.warning_amber, cor: AppTheme.dangerRed),
                  Metrica('Risco médio', formatarPercentual(ind.riscoMedio),
                      Icons.favorite_outline),
                ]),
                const SizedBox(height: 20),
                const TituloSecao('Classificação de risco'),
                GraficoRosca(
                  titulo: 'Pacientes por nível de risco',
                  valores: [
                    for (final nivel in NivelRisco.values)
                      ind.nivel(nivel).toDouble()
                  ],
                  rotulos: [for (final nivel in NivelRisco.values) nivel.rotulo],
                  cores: [for (final nivel in NivelRisco.values) corDoNivel(nivel)],
                ),
                const TituloSecao('Fatores de risco'),
                GraficoRosca(
                  titulo: 'Tabagismo',
                  valores: [ind.fumantes.toDouble(), (n - ind.fumantes).toDouble()],
                  rotulos: const ['Fumantes', 'Não fumantes'],
                  cores: const [AppTheme.dangerRed, AppTheme.primaryGreen],
                ),
                GraficoRosca(
                  titulo: 'Diabetes',
                  valores: [ind.diabeticos.toDouble(), (n - ind.diabeticos).toDouble()],
                  rotulos: const ['Com diabetes', 'Sem diabetes'],
                  cores: const [AppTheme.dangerRed, AppTheme.primaryGreen],
                ),
                GraficoRosca(
                  titulo: 'Remédio para pressão',
                  valores: [
                    ind.usamRemedioPressao.toDouble(),
                    (n - ind.usamRemedioPressao).toDouble()
                  ],
                  rotulos: const ['Usa', 'Não usa'],
                  cores: const [AppTheme.warningYellow, AppTheme.surfaceVariant],
                ),
                const TituloSecao('Perfil'),
                GraficoRosca(
                  titulo: 'Sexo',
                  valores: [ind.masculino.toDouble(), ind.feminino.toDouble()],
                  rotulos: const ['Masculino', 'Feminino'],
                  cores: const [Color(0xFF3498DB), Color(0xFF9B59B6)],
                ),
                const SizedBox(height: 8),
                const TituloSecao('Pacientes que pedem atenção'),
                if (altoRisco.isEmpty)
                  const Text('Nenhum paciente em alto risco.',
                      style: TextStyle(color: AppTheme.textSecondary))
                else
                  for (final a in altoRisco.take(10))
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber,
                            color: AppTheme.dangerRed),
                        title: Text(a.codigoPaciente),
                        subtitle: Text(
                            'Última avaliação em ${formatarData(a.dataHora)}'),
                        trailing: Text(
                            formatarPercentual(a.resultado!.percentual),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetalheAvaliacaoScreen(avaliacao: a),
                            ),
                          );
                          await recarregar();
                        },
                      ),
                    ),
                const SizedBox(height: 12),
                const Text(
                  'Cada paciente é contado uma vez, pela avaliação mais recente. '
                  'Considera só as avaliações deste profissional neste aparelho.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

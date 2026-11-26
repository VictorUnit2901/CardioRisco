import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../data/local/cardiorisco_repository.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/services/relatorio_pdf_service.dart';
import '../avaliacao/formulario_avaliacao_screen.dart';
import '../relatorios/pdf_preview_screen.dart';
import '../shared/cores_risco.dart';
import '../shared/widgets_comuns.dart';
import 'historico_screen.dart' show confirmarExclusao;

/// Tela "ver" de uma avaliação, com editar, excluir e PDF.
class DetalheAvaliacaoScreen extends StatefulWidget {
  const DetalheAvaliacaoScreen({super.key, required this.avaliacao});
  final AvaliacaoModel avaliacao;

  @override
  State<DetalheAvaliacaoScreen> createState() => _DetalheAvaliacaoScreenState();
}

class _DetalheAvaliacaoScreenState extends State<DetalheAvaliacaoScreen> {
  final _repo = CardioRiscoRepository();
  late AvaliacaoModel _a = widget.avaliacao;

  Future<void> _editar() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormularioAvaliacaoScreen(avaliacao: _a)),
    );
    // Depois de editar, relê do aparelho para mostrar os dados novos.
    final lista = await _repo.listarDoProfissionalAtual();
    if (!mounted) return;
    final atualizada = lista.where((x) => x.id == _a.id).firstOrNull;
    if (atualizada != null) setState(() => _a = atualizada);
  }

  Future<void> _excluir() async {
    final ok = await confirmarExclusao(context, _a);
    if (!ok) return;
    await _repo.excluir(_a.id);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _pdf() async {
    final profissional = await _repo.profissionalAtual();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          titulo: 'Avaliação ${_a.codigoPaciente}',
          nomeArquivo: 'avaliacao_${_a.codigoPaciente}.pdf',
          gerar: () => RelatorioPdfService.individual(
              avaliacao: _a, profissional: profissional),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = _a;
    final r = a.resultado;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da avaliação')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(a.codigoPaciente,
              style: Theme.of(context).textTheme.headlineSmall),
          Text(formatarDataHora(a.dataHora),
              style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 18),
          if (r != null)
            MetricGrid(itens: [
              Metrica('Risco em 10 anos', formatarPercentual(r.percentual),
                  Icons.favorite, cor: corDoNivel(r.nivel)),
              Metrica('Classificação', r.nivel.rotulo, Icons.flag,
                  cor: corDoNivel(r.nivel)),
            ])
          else
            const Text('Avaliação ainda sem resultado (rascunho).',
                style: TextStyle(color: AppTheme.warningYellow)),
          const SizedBox(height: 18),
          const TituloSecao('Dados pessoais'),
          LinhaInfo('Idade', a.idade == null ? '-' : '${a.idade} anos'),
          LinhaInfo('Sexo', a.sexo?.rotulo ?? '-'),
          LinhaInfo('Fuma atualmente', simNao(a.fumante)),
          LinhaInfo('Diabetes', simNao(a.diabetico)),
          const SizedBox(height: 10),
          const TituloSecao('Dados clínicos'),
          LinhaInfo('Pressão sistólica',
              a.pressaoSistolica == null ? '-' : '${a.pressaoSistolica} mmHg'),
          LinhaInfo('Usa remédio para pressão', simNao(a.usaRemedioPressao)),
          LinhaInfo('Colesterol total',
              a.colesterolTotal == null ? '-' : '${a.colesterolTotal} mg/dL'),
          LinhaInfo('HDL', a.hdl == null ? '-' : '${a.hdl} mg/dL'),
          if (r != null) LinhaInfo('Modelo de cálculo', r.modelo),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _editar,
            icon: const Icon(Icons.edit),
            label: const Text('EDITAR AVALIAÇÃO'),
          ),
          const SizedBox(height: 10),
          if (r != null)
            OutlinedButton.icon(
              onPressed: _pdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('GERAR PDF DA AVALIAÇÃO'),
            ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _excluir,
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerRed),
            icon: const Icon(Icons.delete_outline),
            label: const Text('EXCLUIR'),
          ),
        ],
      ),
    );
  }
}

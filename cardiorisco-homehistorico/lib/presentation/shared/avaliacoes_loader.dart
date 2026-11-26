import 'package:flutter/material.dart';
import '../../data/local/cardiorisco_repository.dart';
import '../../domain/models/avaliacao_model.dart';

/// Carrega as avaliações do profissional logado e entrega para o [builder].
/// Evita repetir a lógica de carregamento em cada tela.
class AvaliacoesLoader extends StatefulWidget {
  const AvaliacoesLoader({
    super.key,
    required this.builder,
    this.apenasConcluidas = false,
  });

  /// Se true, rascunhos (sem resultado) ficam de fora.
  final bool apenasConcluidas;

  /// Recebe a lista e uma função para recarregar depois de editar/excluir.
  final Widget Function(
    BuildContext context,
    List<AvaliacaoModel> avaliacoes,
    Future<void> Function() recarregar,
  ) builder;

  @override
  State<AvaliacoesLoader> createState() => _AvaliacoesLoaderState();
}

class _AvaliacoesLoaderState extends State<AvaliacoesLoader> {
  final _repo = CardioRiscoRepository();
  List<AvaliacaoModel>? _itens;
  bool _erro = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      var lista = await _repo.listarDoProfissionalAtual();
      if (widget.apenasConcluidas) {
        lista = lista.where((a) => a.resultado != null).toList();
      }
      if (!mounted) return;
      setState(() {
        _itens = lista;
        _erro = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _erro = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_erro) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Não foi possível ler as avaliações do aparelho.'),
            const SizedBox(height: 12),
            OutlinedButton(
                onPressed: _carregar, child: const Text('Tentar de novo')),
          ],
        ),
      );
    }
    final itens = _itens;
    if (itens == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return widget.builder(context, itens, _carregar);
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/profissional_model.dart';
import 'local_storage_service.dart';

/// Leitura para histórico e indicadores. Quem lê e quem salva é o
/// [LocalStorageService]; aqui ficam só a ordenação, o filtro por
/// profissional e a exclusão (que o LocalStorageService ainda não tem).
class CardioRiscoRepository {
  CardioRiscoRepository({LocalStorageService? armazenamento})
      : _armazenamento = armazenamento ?? LocalStorageService();

  final LocalStorageService _armazenamento;

  // Mesma chave do LocalStorageService (lá ela é privada).
  static const _keyAvaliacoesLocais = 'cardiorisco_avaliacoes_locais';

  /// Avaliações do aparelho, da mais recente para a mais antiga.
  Future<List<AvaliacaoModel>> listar({String? profissionalId}) async {
    final todas = await _armazenamento.obterAvaliacoesLocais();
    final lista = profissionalId == null || profissionalId.isEmpty
        ? todas
        : todas.where((a) => a.profissionalId == profissionalId).toList();
    return [...lista]..sort((a, b) => b.dataHora.compareTo(a.dataHora));
  }

  /// Avaliações do profissional logado (ou todas, se não houver sessão salva).
  Future<List<AvaliacaoModel>> listarDoProfissionalAtual() async {
    final p = await profissionalAtual();
    return listar(profissionalId: p?.uid);
  }

  Future<ProfissionalModel?> profissionalAtual() =>
      _armazenamento.obterProfissional();

  /// Remove a avaliação deste aparelho. Não apaga cópia já enviada ao Firestore.
  Future<void> excluir(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = await _armazenamento.obterAvaliacoesLocais();
    lista.removeWhere((a) => a.id == id);
    await prefs.setStringList(
      _keyAvaliacoesLocais,
      lista.map((a) => a.toJson()).toList(),
    );
  }
}

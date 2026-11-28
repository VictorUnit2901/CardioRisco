import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/profissional_model.dart';
import 'local_storage_service.dart';

/// Leitura, exclusão local e auditoria de edição de avaliações.
class CardioRiscoRepository {
  CardioRiscoRepository({
    LocalStorageService? armazenamento,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _armazenamento = armazenamento ?? LocalStorageService(),
        _firestoreInjetado = firestore,
        _authInjetado = auth;

  final LocalStorageService _armazenamento;
  final FirebaseFirestore? _firestoreInjetado;
  final FirebaseAuth? _authInjetado;

  FirebaseFirestore? get _firestore {
    if (_firestoreInjetado != null) return _firestoreInjetado;
    if (Firebase.apps.isEmpty) return null;
    return FirebaseFirestore.instance;
  }

  FirebaseAuth? get _auth {
    if (_authInjetado != null) return _authInjetado;
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAuth.instance;
  }

  // Mesma chave do LocalStorageService (lá ela é privada).
  static const _keyAvaliacoesLocais = 'cardiorisco_avaliacoes_locais';
  static const _colecaoAuditoriaEdicoes = 'auditoria_edicoes';

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

  List<String> _detectarCamposAlterados(
    AvaliacaoModel? anterior,
    AvaliacaoModel atual,
  ) {
    if (anterior == null) return const ['atualizacao_sem_snapshot_anterior'];

    final alterados = <String>[];
    if (anterior.idade != atual.idade) alterados.add('idade');
    if (anterior.sexo != atual.sexo) alterados.add('sexo');
    if (anterior.fumante != atual.fumante) alterados.add('fumante');
    if (anterior.diabetico != atual.diabetico) alterados.add('diabetico');
    if (anterior.pressaoSistolica != atual.pressaoSistolica) {
      alterados.add('pressaoSistolica');
    }
    if (anterior.usaRemedioPressao != atual.usaRemedioPressao) {
      alterados.add('usaRemedioPressao');
    }
    if (anterior.colesterolTotal != atual.colesterolTotal) {
      alterados.add('colesterolTotal');
    }
    if (anterior.hdl != atual.hdl) alterados.add('hdl');
    if (anterior.resultado?.percentual != atual.resultado?.percentual ||
        anterior.resultado?.nivel != atual.resultado?.nivel) {
      alterados.add('resultadoRisco');
    }
    return alterados;
  }

  /// Registra auditoria de edição no Firestore ou enfileira se estiver offline.
  Future<void> registrarEdicaoAvaliacao({
    required AvaliacaoModel avaliacaoAtual,
    AvaliacaoModel? avaliacaoAnterior,
  }) async {
    final profissional = await _armazenamento.obterProfissional();
    final uid = _auth?.currentUser?.uid ??
        (profissional?.uid.isNotEmpty == true
            ? profissional!.uid
            : avaliacaoAtual.profissionalId);

    final camposAlterados =
        _detectarCamposAlterados(avaliacaoAnterior, avaliacaoAtual);

    final registro = <String, dynamic>{
      'uid': uid.isEmpty ? 'anonimo' : uid,
      'acao': 'avaliacao_editada',
      'avaliacaoId': avaliacaoAtual.id,
      'codigoPaciente': avaliacaoAtual.codigoPaciente,
      'camposAlterados': camposAlterados,
      'riscoAnterior': avaliacaoAnterior?.resultado?.percentual,
      'riscoNovo': avaliacaoAtual.resultado?.percentual,
      'dataHora': DateTime.now().toIso8601String(),
    };

    final db = _firestore;
    if (db == null) {
      await _armazenamento.enfileirarAuditoriaEdicao(registro);
      return;
    }

    try {
      await enviarAuditoriaPendente();
      await db.collection(_colecaoAuditoriaEdicoes).add(registro);
    } catch (_) {
      await _armazenamento.enfileirarAuditoriaEdicao(registro);
    }
  }

  /// Envia logs de auditoria de edição que ficaram pendentes offline.
  Future<void> enviarAuditoriaPendente() async {
    final db = _firestore;
    if (db == null) return;

    final rawPendentes = await _armazenamento.obterFilaAuditoriaEdicoes();
    if (rawPendentes.isEmpty) return;

    final restantes = [];
    for (final raw in rawPendentes) {
      if (raw is! Map) continue;
      final item = Map<String, dynamic>.from(raw);
      try {
        await db.collection(_colecaoAuditoriaEdicoes).add(item);
      } catch (_) {
        restantes.add(item);
      }
    }

    await _armazenamento.limparFilaAuditoriaEdicoes();
    for (final item in restantes) {
      await _armazenamento.enfileirarAuditoriaEdicao(item);
    }
  }
}
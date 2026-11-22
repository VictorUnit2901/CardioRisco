import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/profissional_model.dart';
import '../local/local_storage_service.dart';

class PrivacyService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final LocalStorageService _localStorage;

  PrivacyService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    LocalStorageService? localStorage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _localStorage = localStorage ?? LocalStorageService();

  Future<void> registrarAuditoria({
    required String acao,
    String? uid,
    Map<String, dynamic>? detalhes,
  }) async {
    final usuarioId = uid ?? _auth.currentUser?.uid ?? 'anonimo';
    await _firestore.collection('auditoria_privacidade').add({
      'uid': usuarioId,
      'acao': acao,
      'detalhes': detalhes ?? {},
      'dataHora': DateTime.now().toIso8601String(),
    });
  }

  Future<ProfissionalModel?> atualizarConsentimentoPrivacidade(bool aceitou) async {
    final atual = await _localStorage.obterProfissional();
    final uid = _auth.currentUser?.uid ?? atual?.uid;

    if (atual != null) {
      final atualizado = ProfissionalModel(
        uid: atual.uid,
        nome: atual.nome,
        email: atual.email,
        ubs: atual.ubs,
        perfilAcesso: atual.perfilAcesso,
        aceitouPrivacidade: aceitou,
      );
      await _localStorage.salvarProfissional(atualizado);

      if (uid != null && uid.isNotEmpty) {
        await _firestore.collection('profissionais').doc(uid).set(
          {'aceitouPrivacidade': aceitou},
          SetOptions(merge: true),
        );
      }

      await registrarAuditoria(
        acao: aceitou ? 'consentimento_aceito' : 'consentimento_revogado',
        uid: uid,
      );
      return atualizado;
    }

    return null;
  }

  Future<void> excluirContaEDados({bool apagarDadosRemotos = true}) async {
    final user = _auth.currentUser;
    final uid = user?.uid;

    if (uid != null && uid.isNotEmpty) {
      await registrarAuditoria(
        acao: 'solicitacao_exclusao_conta',
        uid: uid,
        detalhes: {'apagarDadosRemotos': apagarDadosRemotos},
      );

      if (apagarDadosRemotos) {
        final avaliacoesSnap = await _firestore
            .collection('avaliacoes')
            .where('profissionalId', isEqualTo: uid)
            .get();

        final batch = _firestore.batch();
        for (final doc in avaliacoesSnap.docs) {
          batch.delete(doc.reference);
        }
        batch.delete(_firestore.collection('profissionais').doc(uid));
        await batch.commit();
      }
    }

    await _localStorage.limparTodosDadosLocais();

    if (user != null) {
      await user.delete();
    }
  }
}
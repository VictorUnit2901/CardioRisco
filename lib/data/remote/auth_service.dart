import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/profissional_model.dart';
import '../local/local_storage_service.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final LocalStorageService _localStorage;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    LocalStorageService? localStorage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _localStorage = localStorage ?? LocalStorageService();

  User? get usuarioAtual => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<ProfissionalModel?> login({
    required String email,
    required String senha,
  }) async {
    final credencial = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    final user = credencial.user;
    if (user == null) return null;

    final doc = await _firestore.collection('profissionais').doc(user.uid).get();
    final profissional = doc.exists && doc.data() != null
        ? ProfissionalModel.fromMap({
            ...doc.data()!,
            'uid': user.uid,
            'email': user.email ?? doc.data()!['email'] ?? '',
          })
        : ProfissionalModel(
            uid: user.uid,
            nome: user.displayName ?? '',
            email: user.email ?? email.trim(),
            ubs: '',
            perfilAcesso: 'ACS',
            aceitouPrivacidade: false,
          );

    await _localStorage.salvarProfissional(profissional);
    return profissional;
  }

  Future<ProfissionalModel?> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String ubs,
    required String perfilAcesso,
    required bool aceitouPrivacidade,
  }) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    final user = credencial.user;
    if (user == null) return null;

    await user.updateDisplayName(nome.trim());

    final profissional = ProfissionalModel(
      uid: user.uid,
      nome: nome.trim(),
      email: email.trim(),
      ubs: ubs.trim(),
      perfilAcesso: perfilAcesso,
      aceitouPrivacidade: aceitouPrivacidade,
    );

    await _firestore
        .collection('profissionais')
        .doc(user.uid)
        .set(profissional.toMap(), SetOptions(merge: true));

    await _localStorage.salvarProfissional(profissional);
    return profissional;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
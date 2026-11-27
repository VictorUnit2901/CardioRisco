import 'dart:async';
import 'dart:io';
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

  String _normalizarEmail(String email) => email.trim().toLowerCase();

  ProfissionalModel _reconstruirComUid(
    ProfissionalModel base,
    String uid,
  ) {
    return ProfissionalModel(
      uid: uid,
      nome: base.nome,
      email: base.email,
      ubs: base.ubs,
      perfilAcesso: base.perfilAcesso,
      aceitouPrivacidade: base.aceitouPrivacidade,
    );
  }

  Future<ProfissionalModel?> obterProfissionalSalvo() {
    return _localStorage.obterProfissional();
  }

  /// Permite entrar offline APENAS se já existir um perfil cadastrado e salvo
  /// localmente para o mesmo e-mail (evita criar conta duplicada ou falsa).
  Future<ProfissionalModel?> entrarOffline({required String email}) async {
    final salvo = await _localStorage.obterProfissional();
    if (salvo == null) return null;

    final emailInformado = _normalizarEmail(email);
    final emailSalvo = _normalizarEmail(salvo.email);

    if (emailSalvo.isEmpty || emailInformado != emailSalvo) {
      return null;
    }

    return salvo;
  }

  bool _isErroDeRede(Object error) {
    if (error is SocketException || error is TimeoutException) {
      return true;
    }
    if (error is FirebaseAuthException &&
        error.code == 'network-request-failed') {
      return true;
    }
    if (error is FirebaseException && error.code == 'unavailable') {
      return true;
    }
    final texto = error.toString().toLowerCase();
    return texto.contains('network') ||
        texto.contains('socket') ||
        texto.contains('unavailable') ||
        texto.contains('timed out');
  }

  Future<ProfissionalModel?> login({
    required String email,
    required String senha,
  }) async {
    final emailLimpo = email.trim();

    try {
      final credencial = await _auth
          .signInWithEmailAndPassword(
            email: emailLimpo,
            password: senha,
          )
          .timeout(const Duration(seconds: 12));

      final user = credencial.user;
      if (user == null) return null;

      final salvoLocal = await _localStorage.obterProfissional();
      final mesmoPerfilLocal = salvoLocal != null &&
          (salvoLocal.uid == user.uid ||
              _normalizarEmail(salvoLocal.email) ==
                  _normalizarEmail(user.email ?? emailLimpo));

      ProfissionalModel profissional;
      try {
        final doc = await _firestore
            .collection('profissionais')
            .doc(user.uid)
            .get()
            .timeout(const Duration(seconds: 8));

        if (doc.exists && doc.data() != null) {
          profissional = ProfissionalModel.fromMap({
            ...doc.data()!,
            'uid': user.uid,
            'email': user.email ?? doc.data()!['email'] ?? emailLimpo,
          });
        } else if (mesmoPerfilLocal) {
          profissional = _reconstruirComUid(salvoLocal, user.uid);
          await _firestore
              .collection('profissionais')
              .doc(user.uid)
              .set(profissional.toMap(), SetOptions(merge: true));
        } else {
          profissional = ProfissionalModel(
            uid: user.uid,
            nome: user.displayName ?? '',
            email: user.email ?? emailLimpo,
            ubs: '',
            perfilAcesso: 'ACS',
            aceitouPrivacidade: false,
          );
        }
      } catch (_) {
        profissional = mesmoPerfilLocal
            ? _reconstruirComUid(salvoLocal, user.uid)
            : ProfissionalModel(
                uid: user.uid,
                nome: user.displayName ?? '',
                email: user.email ?? emailLimpo,
                ubs: '',
                perfilAcesso: 'ACS',
                aceitouPrivacidade: false,
              );
      }

      await _localStorage.salvarProfissional(profissional);
      return profissional;
    } catch (e) {
      if (_isErroDeRede(e)) {
        final offlineUser = await entrarOffline(email: emailLimpo);
        if (offlineUser != null) {
          return offlineUser;
        }
      }
      rethrow;
    }
  }

  Future<ProfissionalModel?> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String ubs,
    required String perfilAcesso,
    required bool aceitouPrivacidade,
  }) async {
    final emailLimpo = email.trim();

    final credencial = await _auth.createUserWithEmailAndPassword(
      email: emailLimpo,
      password: senha,
    );

    final user = credencial.user;
    if (user == null) return null;

    await user.updateDisplayName(nome.trim());

    final profissional = ProfissionalModel(
      uid: user.uid,
      nome: nome.trim(),
      email: user.email ?? emailLimpo,
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
    try {
      await _auth.signOut().timeout(const Duration(seconds: 5));
    } catch (_) {
      // Permite encerrar a sessão ativa mesmo sem rede
    }
  }
}
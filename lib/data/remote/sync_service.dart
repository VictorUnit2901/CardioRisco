import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/models/avaliacao_model.dart';
import '../local/local_storage_service.dart';

class SyncService {
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;
  final LocalStorageService _localStorage;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _sincronizando = false;

  SyncService({
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
    LocalStorageService? localStorage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _connectivity = connectivity ?? Connectivity(),
        _localStorage = localStorage ?? LocalStorageService();

  Future<bool> podeSincronizarAgora() async {
    final resultados = await _connectivity.checkConnectivity();
    if (resultados.isEmpty || resultados.contains(ConnectivityResult.none)) {
      return false;
    }

    final apenasWifi = await _localStorage.obterApenasWifi();
    if (apenasWifi) {
      return resultados.contains(ConnectivityResult.wifi);
    }

    return resultados.contains(ConnectivityResult.wifi) ||
        resultados.contains(ConnectivityResult.mobile) ||
        resultados.contains(ConnectivityResult.ethernet);
  }

  Future<int> sincronizarPendentes() async {
    final pendentes = await _localStorage.obterPendentesSincronizacao();
    var sincronizadasCount = 0;

    for (final AvaliacaoModel avaliacao in pendentes) {
      if (avaliacao.id.isEmpty) continue;

      final payload = {
        ...avaliacao.toMap(),
        'statusSync': StatusSincronizacao.sincronizado.name,
        'sincronizadoEm': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection('avaliacoes')
          .doc(avaliacao.id)
          .set(payload, SetOptions(merge: true));

      await _localStorage.marcarComoSincronizada(avaliacao.id);
      sincronizadasCount++;
    }

    return sincronizadasCount;
  }

  /// Recupera as avaliações do Firestore vinculadas ao `profissionalId`
  /// e mescla com o armazenamento local sem duplicar registros.
  Future<int> recuperarAvaliacoesDaNuvem(String profissionalId) async {
    if (profissionalId.trim().isEmpty) return 0;

    final snapshot = await _firestore
        .collection('avaliacoes')
        .where('profissionalId', isEqualTo: profissionalId.trim())
        .get();

    final remotas = snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = (data['id'] as String?)?.isNotEmpty == true
          ? data['id']
          : doc.id;
      data['statusSync'] = StatusSincronizacao.sincronizado.name;
      return AvaliacaoModel.fromMap(data);
    }).toList();

    await _localStorage.mesclarAvaliacoesRemotas(
      remotas,
      profissionalId: profissionalId.trim(),
    );

    return remotas.length;
  }

  /// Executa envio de pendentes e recuperação/mesclagem da nuvem quando há rede.
  Future<int> sincronizarTudo({String? profissionalId}) async {
    if (_sincronizando) return 0;
    _sincronizando = true;

    try {
      final liberado = await podeSincronizarAgora();
      if (!liberado) return 0;

      final enviados = await sincronizarPendentes();

      var uidAlvo = profissionalId?.trim() ?? '';
      if (uidAlvo.isEmpty) {
        final profissionalSalvo = await _localStorage.obterProfissional();
        uidAlvo = profissionalSalvo?.uid.trim() ?? '';
      }

      if (uidAlvo.isNotEmpty) {
        await recuperarAvaliacoesDaNuvem(uidAlvo);
      }

      return enviados;
    } finally {
      _sincronizando = false;
    }
  }

  void iniciarMonitoramentoAutomatico({String? profissionalId}) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_) async {
      await sincronizarTudo(profissionalId: profissionalId);
    });
  }

  void pararMonitoramentoAutomatico() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
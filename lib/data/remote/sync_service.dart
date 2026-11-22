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
    if (_sincronizando) return 0;
    _sincronizando = true;

    try {
      final liberado = await podeSincronizarAgora();
      if (!liberado) return 0;

      final pendentes = await _localStorage.obterPendentesSincronizacao();
      var sincronizadasCount = 0;

      for (final AvaliacaoModel avaliacao in pendentes) {
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
    } finally {
      _sincronizando = false;
    }
  }

  void iniciarMonitoramentoAutomatico() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((_) async {
      await sincronizarPendentes();
    });
  }

  void pararMonitoramentoAutomatico() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
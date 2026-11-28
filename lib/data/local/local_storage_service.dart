import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/profissional_model.dart';

class LocalStorageService {
  static const _keyProfissional = 'cardiorisco_profissional';
  static const _keyCredenciaisOffline = 'cardiorisco_credenciais_offline_v1';
  static const _keyRascunhoAvaliacao = 'cardiorisco_rascunho_avaliacao';
  static const _keyAvaliacoesLocais = 'cardiorisco_avaliacoes_locais';
  static const _keyUltimoCodigoPaciente = 'cardiorisco_ultimo_codigo_paciente';
  static const _keyApenasWifi = 'cardiorisco_apenas_wifi';

  String _normalizarEmailLocal(String email) => email.trim().toLowerCase();

  String _gerarSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _gerarHashSenha(String senha, String salt) {
    final bytes = utf8.encode('$salt:$senha');
    return sha256.convert(bytes).toString();
  }

  // --- Sessão / Perfil ---
  Future<void> salvarProfissional(ProfissionalModel profissional) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfissional, jsonEncode(profissional.toMap()));
  }

  Future<ProfissionalModel?> obterProfissional() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProfissional);
    if (raw == null || raw.isEmpty) return null;
    return ProfissionalModel.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> limparProfissional() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfissional);
  }

  // --- Credenciais Offline (SHA-256 + salt) ---
  Future<void> salvarCredencialOffline({
    required String email,
    required String senha,
  }) async {
    final emailNormalizado = _normalizarEmailLocal(email);
    if (emailNormalizado.isEmpty || senha.isEmpty) return;

    final salt = _gerarSalt();
    final hash = _gerarHashSenha(senha, salt);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCredenciaisOffline);
    final mapa = raw != null && raw.isNotEmpty
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : <String, dynamic>{};

    mapa[emailNormalizado] = {
      'salt': salt,
      'hash': hash,
    };

    await prefs.setString(_keyCredenciaisOffline, jsonEncode(mapa));
  }

  Future<bool> validarCredencialOffline({
    required String email,
    required String senha,
  }) async {
    final emailNormalizado = _normalizarEmailLocal(email);
    if (emailNormalizado.isEmpty || senha.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyCredenciaisOffline);
    if (raw == null || raw.isEmpty) return false;

    final mapa = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    final registro = mapa[emailNormalizado];
    if (registro is! Map) return false;

    final salt = registro['salt']?.toString() ?? '';
    final hashSalvo = registro['hash']?.toString() ?? '';
    if (salt.isEmpty || hashSalvo.isEmpty) return false;

    final hashDigitado = _gerarHashSenha(senha, salt);
    return hashDigitado == hashSalvo;
  }

  // --- Preferência de Wi-Fi ---
  Future<void> definirApenasWifi(bool apenasWifi) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyApenasWifi, apenasWifi);
  }

  Future<bool> obterApenasWifi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyApenasWifi) ?? true;
  }

  // --- Geração de código anônimo (P-0001, P-0002...) ---
  Future<String> gerarProximoCodigoPaciente() async {
    final prefs = await SharedPreferences.getInstance();
    final proximo = (prefs.getInt(_keyUltimoCodigoPaciente) ?? 0) + 1;
    await prefs.setInt(_keyUltimoCodigoPaciente, proximo);
    return 'P-${proximo.toString().padLeft(4, '0')}';
  }

  // --- Salvamento automático de rascunho ---
  Future<void> salvarRascunho(AvaliacaoModel rascunho) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyRascunhoAvaliacao,
      rascunho
          .copyWith(
            statusSync: StatusSincronizacao.rascunho,
            atualizadoEm: DateTime.now(),
          )
          .toJson(),
    );
  }

  Future<AvaliacaoModel?> obterRascunho() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyRascunhoAvaliacao);
    if (raw == null || raw.isEmpty) return null;
    return AvaliacaoModel.fromJson(raw);
  }

  Future<void> limparRascunho() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRascunhoAvaliacao);
  }

  // --- Fila offline e avaliações locais ---
  Future<List<AvaliacaoModel>> obterAvaliacoesLocais() async {
    final prefs = await SharedPreferences.getInstance();
    final listaRaw = prefs.getStringList(_keyAvaliacoesLocais) ?? [];
    return listaRaw.map((item) => AvaliacaoModel.fromJson(item)).toList();
  }

  Future<void> salvarAvaliacoesLocais(List<AvaliacaoModel> avaliacoes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keyAvaliacoesLocais,
      avaliacoes.map((a) => a.toJson()).toList(),
    );
  }

  Future<void> salvarAvaliacaoNaFila(AvaliacaoModel avaliacao) async {
    final atuais = await obterAvaliacoesLocais();

    final itemPreparado = avaliacao.copyWith(
      statusSync: StatusSincronizacao.pendenteEnvio,
      atualizadoEm: DateTime.now(),
    );

    final indiceExistente = atuais.indexWhere((a) => a.id == itemPreparado.id);
    if (indiceExistente >= 0) {
      atuais[indiceExistente] = itemPreparado;
    } else {
      atuais.add(itemPreparado);
    }

    await salvarAvaliacoesLocais(atuais);
  }

  Future<List<AvaliacaoModel>> obterPendentesSincronizacao() async {
    final todas = await obterAvaliacoesLocais();
    return todas
        .where((a) => a.statusSync == StatusSincronizacao.pendenteEnvio)
        .toList();
  }

  Future<void> marcarComoSincronizada(String idAvaliacao) async {
    final atuais = await obterAvaliacoesLocais();

    final atualizadas = atuais.map((a) {
      if (a.id == idAvaliacao) {
        return a.copyWith(
          statusSync: StatusSincronizacao.sincronizado,
          atualizadoEm: DateTime.now(),
        );
      }
      return a;
    }).toList();

    await salvarAvaliacoesLocais(atualizadas);
  }

  /// Mescla avaliações recuperadas do Firestore com as avaliações locais
  /// sem criar duplicatas (chaveada por `id`).
  /// Se o item local ainda estiver como `pendenteEnvio`, preserva a versão local
  /// para que ela seja enviada antes de ser sobrescrita.
  Future<void> mesclarAvaliacoesRemotas(
    List<AvaliacaoModel> remotas, {
    String? profissionalId,
  }) async {
    final atuais = await obterAvaliacoesLocais();
    final porId = <String, AvaliacaoModel>{
      for (final item in atuais)
        if (item.id.isNotEmpty) item.id: item,
    };

    for (final remota in remotas) {
      if (remota.id.isEmpty) continue;
      if (profissionalId != null &&
          profissionalId.isNotEmpty &&
          remota.profissionalId.isNotEmpty &&
          remota.profissionalId != profissionalId) {
        continue;
      }

      final localExistente = porId[remota.id];
      if (localExistente != null &&
          localExistente.statusSync == StatusSincronizacao.pendenteEnvio) {
        continue;
      }

      final normalizada = remota.copyWith(
        statusSync: StatusSincronizacao.sincronizado,
      );
      porId[remota.id] = normalizada;
    }

    final resultado = porId.values.toList()
      ..sort((a, b) => b.dataHora.compareTo(a.dataHora));

    await salvarAvaliacoesLocais(resultado);
  }

  // --- Exclusão definitiva dos dados locais ---
  Future<void> limparTodosDadosLocais() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfissional);
    await prefs.remove(_keyCredenciaisOffline);
    await prefs.remove(_keyRascunhoAvaliacao);
    await prefs.remove(_keyAvaliacoesLocais);
    await prefs.remove(_keyUltimoCodigoPaciente);
    await prefs.remove(_keyApenasWifi);
  }
}
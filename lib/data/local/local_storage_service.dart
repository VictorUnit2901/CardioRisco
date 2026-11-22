import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/profissional_model.dart';

class LocalStorageService {
  static const _keyProfissional = 'cardiorisco_profissional';
  static const _keyRascunhoAvaliacao = 'cardiorisco_rascunho_avaliacao';
  static const _keyAvaliacoesLocais = 'cardiorisco_avaliacoes_locais';
  static const _keyUltimoCodigoPaciente = 'cardiorisco_ultimo_codigo_paciente';
  static const _keyApenasWifi = 'cardiorisco_apenas_wifi';

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

  // --- Preferência de Wi-Fi ---
  Future<void> definirApenasWifi(bool apenasWifi) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyApenasWifi, apenasWifi);
  }

  Future<bool> obterApenasWifi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyApenasWifi) ?? true; // Padrão: enviar apenas por Wi-Fi
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
      rascunho.copyWith(
        statusSync: StatusSincronizacao.rascunho,
        atualizadoEm: DateTime.now(),
      ).toJson(),
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

  Future<void> salvarAvaliacaoNaFila(AvaliacaoModel avaliacao) async {
    final prefs = await SharedPreferences.getInstance();
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

    await prefs.setStringList(
      _keyAvaliacoesLocais,
      atuais.map((a) => a.toJson()).toList(),
    );
  }

  Future<List<AvaliacaoModel>> obterPendentesSincronizacao() async {
    final todas = await obterAvaliacoesLocais();
    return todas
        .where((a) => a.statusSync == StatusSincronizacao.pendenteEnvio)
        .toList();
  }

  Future<void> marcarComoSincronizada(String idAvaliacao) async {
    final prefs = await SharedPreferences.getInstance();
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

    await prefs.setStringList(
      _keyAvaliacoesLocais,
      atualizadas.map((a) => a.toJson()).toList(),
    );
  }

  // --- Exclusão definitiva dos dados locais ---
  Future<void> limparTodosDadosLocais() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfissional);
    await prefs.remove(_keyRascunhoAvaliacao);
    await prefs.remove(_keyAvaliacoesLocais);
    await prefs.remove(_keyUltimoCodigoPaciente);
    await prefs.remove(_keyApenasWifi);
  }
}
import 'dart:convert';

enum StatusSincronizacao {
  rascunho,
  pendenteEnvio,
  sincronizado,
}

class AvaliacaoModel {
  final String id;
  final String codigoPaciente; // Ex.: P-0013 (sem nome ou CPF)
  final String profissionalId;
  final DateTime dataHora;
  final int etapaAtual; // Ex.: 1 ou 2 para retomada de rascunho
  final int? idade;
  final String? sexo; // 'Masculino' ou 'Feminino'
  final bool? fumante;
  final bool? diabetico;
  final int? pressaoSistolica;
  final bool? usaRemedioPressao;
  final int? colesterolTotal;
  final int? hdl;
  final double? percentualRisco;
  final String? classificacaoRisco; // 'Baixo', 'Intermediário', 'Alto'
  final StatusSincronizacao statusSync;
  final DateTime atualizadoEm;

  const AvaliacaoModel({
    required this.id,
    required this.codigoPaciente,
    required this.profissionalId,
    required this.dataHora,
    this.etapaAtual = 1,
    this.idade,
    this.sexo,
    this.fumante,
    this.diabetico,
    this.pressaoSistolica,
    this.usaRemedioPressao,
    this.colesterolTotal,
    this.hdl,
    this.percentualRisco,
    this.classificacaoRisco,
    this.statusSync = StatusSincronizacao.rascunho,
    required this.atualizadoEm,
  });

  AvaliacaoModel copyWith({
    String? id,
    String? codigoPaciente,
    String? profissionalId,
    DateTime? dataHora,
    int? etapaAtual,
    int? idade,
    String? sexo,
    bool? fumante,
    bool? diabetico,
    int? pressaoSistolica,
    bool? usaRemedioPressao,
    int? colesterolTotal,
    int? hdl,
    double? percentualRisco,
    String? classificacaoRisco,
    StatusSincronizacao? statusSync,
    DateTime? atualizadoEm,
  }) {
    return AvaliacaoModel(
      id: id ?? this.id,
      codigoPaciente: codigoPaciente ?? this.codigoPaciente,
      profissionalId: profissionalId ?? this.profissionalId,
      dataHora: dataHora ?? this.dataHora,
      etapaAtual: etapaAtual ?? this.etapaAtual,
      idade: idade ?? this.idade,
      sexo: sexo ?? this.sexo,
      fumante: fumante ?? this.fumante,
      diabetico: diabetico ?? this.diabetico,
      pressaoSistolica: pressaoSistolica ?? this.pressaoSistolica,
      usaRemedioPressao: usaRemedioPressao ?? this.usaRemedioPressao,
      colesterolTotal: colesterolTotal ?? this.colesterolTotal,
      hdl: hdl ?? this.hdl,
      percentualRisco: percentualRisco ?? this.percentualRisco,
      classificacaoRisco: classificacaoRisco ?? this.classificacaoRisco,
      statusSync: statusSync ?? this.statusSync,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigoPaciente': codigoPaciente,
      'profissionalId': profissionalId,
      'dataHora': dataHora.toIso8601String(),
      'etapaAtual': etapaAtual,
      'idade': idade,
      'sexo': sexo,
      'fumante': fumante,
      'diabetico': diabetico,
      'pressaoSistolica': pressaoSistolica,
      'usaRemedioPressao': usaRemedioPressao,
      'colesterolTotal': colesterolTotal,
      'hdl': hdl,
      'percentualRisco': percentualRisco,
      'classificacaoRisco': classificacaoRisco,
      'statusSync': statusSync.name,
      'atualizadoEm': atualizadoEm.toIso8601String(),
    };
  }

  factory AvaliacaoModel.fromMap(Map<String, dynamic> map) {
    final statusNome = map['statusSync'] as String? ?? 'rascunho';
    final status = StatusSincronizacao.values.firstWhere(
      (e) => e.name == statusNome,
      orElse: () => StatusSincronizacao.rascunho,
    );

    return AvaliacaoModel(
      id: map['id'] as String? ?? '',
      codigoPaciente: map['codigoPaciente'] as String? ?? '',
      profissionalId: map['profissionalId'] as String? ?? '',
      dataHora: DateTime.tryParse(map['dataHora'] as String? ?? '') ?? DateTime.now(),
      etapaAtual: map['etapaAtual'] as int? ?? 1,
      idade: map['idade'] as int?,
      sexo: map['sexo'] as String?,
      fumante: map['fumante'] as bool?,
      diabetico: map['diabetico'] as bool?,
      pressaoSistolica: map['pressaoSistolica'] as int?,
      usaRemedioPressao: map['usaRemedioPressao'] as bool?,
      colesterolTotal: map['colesterolTotal'] as int?,
      hdl: map['hdl'] as int?,
      percentualRisco: (map['percentualRisco'] as num?)?.toDouble(),
      classificacaoRisco: map['classificacaoRisco'] as String?,
      statusSync: status,
      atualizadoEm: DateTime.tryParse(map['atualizadoEm'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AvaliacaoModel.fromJson(String source) =>
      AvaliacaoModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
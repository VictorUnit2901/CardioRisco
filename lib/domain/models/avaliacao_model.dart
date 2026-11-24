import 'dart:convert';

import 'enums_avaliacao.dart';
import 'resultado_risco.dart';

/// Situação da avaliação no aparelho e na nuvem.
enum StatusSincronizacao {
  /// Formulário em andamento, salvo automaticamente.
  rascunho,

  /// Avaliação concluída, na fila local esperando Wi-Fi.
  pendenteEnvio,

  /// Avaliação já enviada ao Firestore.
  sincronizado,
}

/// Uma avaliação de risco cardiovascular feita numa visita domiciliar.
///
/// Guarda as respostas do formulário, o resultado do cálculo e a
/// situação de envio. Não guarda nome nem CPF: o paciente é
/// identificado só pelo código (ex.: P-0013).
class AvaliacaoModel {
  // Faixas aceitas na validação clínica (ver docs/diagramaClasses.md).
  static const idadeMinima = 30;
  static const idadeMaxima = 74;
  static const pressaoMinima = 70;
  static const pressaoMaxima = 250;
  static const colesterolMinimo = 70;
  static const colesterolMaximo = 500;
  static const hdlMinimo = 10;
  static const hdlMaximo = 150;

  final String id;
  final String codigoPaciente; // Ex.: P-0013 (sem nome ou CPF)
  final String profissionalId;
  final DateTime dataHora;
  final int etapaAtual; // 1 ou 2, para retomar o rascunho na etapa certa

  // Etapa 1 do formulário: dados demográficos e comportamentais
  final int? idade;
  final Sexo? sexo;
  final bool? fumante;
  final bool? diabetico;

  // Etapa 2 do formulário: dados clínicos medidos
  final int? pressaoSistolica;
  final bool? usaRemedioPressao;
  final int? colesterolTotal;
  final int? hdl;

  /// Resultado do cálculo. Fica vazio enquanto a avaliação é rascunho.
  final ResultadoRisco? resultado;

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
    this.resultado,
    this.statusSync = StatusSincronizacao.rascunho,
    required this.atualizadoEm,
  });

  /// Diz se todas as perguntas do formulário foram respondidas.
  bool estaCompleta() {
    return idade != null &&
        sexo != null &&
        fumante != null &&
        diabetico != null &&
        pressaoSistolica != null &&
        usaRemedioPressao != null &&
        colesterolTotal != null &&
        hdl != null;
  }

  /// Validação clínica: devolve a lista de problemas encontrados.
  /// Se a lista vier vazia, a avaliação pode ir para o cálculo.
  ///
  /// [etapa] permite validar só uma parte do formulário:
  /// 1 = dados pessoais, 2 = dados clínicos, vazio = tudo.
  List<String> validar({int? etapa}) {
    final erros = <String>[];
    if (etapa == null || etapa == 1) {
      erros.addAll(_validarDadosPessoais());
    }
    if (etapa == null || etapa == 2) {
      erros.addAll(_validarDadosClinicos());
    }
    return erros;
  }

  /// Etapa 1: idade, sexo, tabagismo e diabetes.
  List<String> _validarDadosPessoais() {
    final erros = <String>[];

    final idade = this.idade;
    if (idade == null) {
      erros.add('Informe a idade.');
    } else if (idade < idadeMinima || idade > idadeMaxima) {
      erros.add(
          'A idade deve estar entre $idadeMinima e $idadeMaxima anos (faixa do escore).');
    }

    if (sexo == null) {
      erros.add('Informe o sexo.');
    }
    if (fumante == null) {
      erros.add('Informe se o paciente fuma.');
    }
    if (diabetico == null) {
      erros.add('Informe se o paciente tem diabetes.');
    }

    return erros;
  }

  /// Etapa 2: pressão, remédio para pressão, colesterol total e HDL.
  List<String> _validarDadosClinicos() {
    final erros = <String>[];

    final pressao = pressaoSistolica;
    if (pressao == null) {
      erros.add('Informe a pressão arterial sistólica.');
    } else if (pressao < pressaoMinima || pressao > pressaoMaxima) {
      erros.add(
          'A pressão sistólica deve estar entre $pressaoMinima e $pressaoMaxima mmHg.');
    }

    if (usaRemedioPressao == null) {
      erros.add('Informe se o paciente usa remédio para pressão.');
    }

    final colesterol = colesterolTotal;
    if (colesterol == null) {
      erros.add('Informe o colesterol total.');
    } else if (colesterol < colesterolMinimo || colesterol > colesterolMaximo) {
      erros.add(
          'O colesterol total deve estar entre $colesterolMinimo e $colesterolMaximo mg/dL.');
    }

    final hdl = this.hdl;
    if (hdl == null) {
      erros.add('Informe o HDL.');
    } else if (hdl < hdlMinimo || hdl > hdlMaximo) {
      erros.add('O HDL deve estar entre $hdlMinimo e $hdlMaximo mg/dL.');
    } else if (colesterol != null && hdl >= colesterol) {
      erros.add('O HDL deve ser menor que o colesterol total.');
    }

    return erros;
  }

  AvaliacaoModel copyWith({
    String? id,
    String? codigoPaciente,
    String? profissionalId,
    DateTime? dataHora,
    int? etapaAtual,
    int? idade,
    Sexo? sexo,
    bool? fumante,
    bool? diabetico,
    int? pressaoSistolica,
    bool? usaRemedioPressao,
    int? colesterolTotal,
    int? hdl,
    ResultadoRisco? resultado,
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
      resultado: resultado ?? this.resultado,
      statusSync: statusSync ?? this.statusSync,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  /// Converte para um mapa simples, usado para salvar no aparelho
  /// e no Firestore. O resultado vai em campos separados.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigoPaciente': codigoPaciente,
      'profissionalId': profissionalId,
      'dataHora': dataHora.toIso8601String(),
      'etapaAtual': etapaAtual,
      'idade': idade,
      'sexo': sexo?.name,
      'fumante': fumante,
      'diabetico': diabetico,
      'pressaoSistolica': pressaoSistolica,
      'usaRemedioPressao': usaRemedioPressao,
      'colesterolTotal': colesterolTotal,
      'hdl': hdl,
      'percentualRisco': resultado?.percentual,
      'classificacaoRisco': resultado?.nivel.name,
      'modeloRisco': resultado?.modelo,
      'calculadoEm': resultado?.calculadoEm.toIso8601String(),
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
    final sexo = _lerSexo(map['sexo'] as String?);

    return AvaliacaoModel(
      id: map['id'] as String? ?? '',
      codigoPaciente: map['codigoPaciente'] as String? ?? '',
      profissionalId: map['profissionalId'] as String? ?? '',
      dataHora:
          DateTime.tryParse(map['dataHora'] as String? ?? '') ?? DateTime.now(),
      etapaAtual: map['etapaAtual'] as int? ?? 1,
      idade: map['idade'] as int?,
      sexo: sexo,
      fumante: map['fumante'] as bool?,
      diabetico: map['diabetico'] as bool?,
      pressaoSistolica: map['pressaoSistolica'] as int?,
      usaRemedioPressao: map['usaRemedioPressao'] as bool?,
      colesterolTotal: map['colesterolTotal'] as int?,
      hdl: map['hdl'] as int?,
      resultado: _lerResultado(map, sexo),
      statusSync: status,
      atualizadoEm: DateTime.tryParse(map['atualizadoEm'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AvaliacaoModel.fromJson(String source) =>
      AvaliacaoModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  /// Lê o sexo salvo. Aceita o nome do enum ('masculino') e também
  /// o texto antigo ('Masculino'), para não perder rascunhos já salvos.
  static Sexo? _lerSexo(String? texto) {
    for (final opcao in Sexo.values) {
      if (opcao.name == texto || opcao.rotulo == texto) {
        return opcao;
      }
    }
    return null;
  }

  /// Monta o resultado a partir dos campos separados do mapa.
  static ResultadoRisco? _lerResultado(Map<String, dynamic> map, Sexo? sexo) {
    final percentual = (map['percentualRisco'] as num?)?.toDouble();
    if (percentual == null) {
      return null;
    }

    final textoNivel = map['classificacaoRisco'] as String?;
    NivelRisco? nivel;
    for (final opcao in NivelRisco.values) {
      if (opcao.name == textoNivel || opcao.rotulo == textoNivel) {
        nivel = opcao;
      }
    }
    if (nivel == null && sexo != null) {
      nivel = ResultadoRisco.classificar(percentual, sexo);
    }
    if (nivel == null) {
      return null;
    }

    return ResultadoRisco(
      percentual: percentual,
      nivel: nivel,
      modelo: map['modeloRisco'] as String? ?? 'Framingham',
      calculadoEm: DateTime.tryParse(map['calculadoEm'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

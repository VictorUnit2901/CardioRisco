import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/local/local_storage_service.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../../domain/services/calculadora_framingham.dart';
import '../../domain/services/calculadora_risco.dart';

/// Guarda o estado do formulário de avaliação (Telas 1 e 2) e avisa a
/// tela sempre que algo muda. É o padrão do Provider: a tela "escuta"
/// este controlador e se redesenha quando ele chama notifyListeners().
class FormularioAvaliacaoController extends ChangeNotifier {
  FormularioAvaliacaoController({
    LocalStorageService? armazenamento,
    this.calculadora = const CalculadoraFramingham(),
  }) : _armazenamento = armazenamento ?? LocalStorageService();

  final LocalStorageService _armazenamento;

  /// Modelo de risco usado no cálculo (Framingham, se nada for passado).
  final CalculadoraRisco calculadora;
  Timer? _temporizadorSalvamento;
  bool _descartado = false;

  /// Dados fixos da avaliação: id, código do paciente, profissional e data.
  AvaliacaoModel? _base;

  bool _carregando = true;
  bool _modoEdicao = false;
  bool _rascunhoSalvo = false;
  int _etapa = 1;
  List<String> _erros = const [];

  // Respostas do formulário (podem ficar vazias enquanto é rascunho).
  int? _idade;
  Sexo? _sexo;
  bool? _fumante;
  bool? _diabetico;
  int? _pressaoSistolica;
  bool? _usaRemedioPressao;
  int? _colesterolTotal;
  int? _hdl;

  bool get carregando => _carregando;
  bool get modoEdicao => _modoEdicao;
  bool get rascunhoSalvo => _rascunhoSalvo;
  int get etapa => _etapa;
  List<String> get erros => _erros;
  String get codigoPaciente => _base?.codigoPaciente ?? '';

  int? get idade => _idade;
  Sexo? get sexo => _sexo;
  bool? get fumante => _fumante;
  bool? get diabetico => _diabetico;
  int? get pressaoSistolica => _pressaoSistolica;
  bool? get usaRemedioPressao => _usaRemedioPressao;
  int? get colesterolTotal => _colesterolTotal;
  int? get hdl => _hdl;

  /// Prepara o formulário em um destes casos:
  /// - edição de uma avaliação já salva (vinda do histórico);
  /// - retomada do rascunho salvo automaticamente;
  /// - avaliação nova, com código de paciente gerado pelo app.
  Future<void> iniciar({AvaliacaoModel? avaliacaoExistente}) async {
    final AvaliacaoModel inicial;
    if (avaliacaoExistente != null) {
      _modoEdicao = true;
      _etapa = 1;
      inicial = avaliacaoExistente;
    } else {
      final rascunho = await _armazenamento.obterRascunho();
      if (rascunho != null) {
        _etapa = rascunho.etapaAtual;
        _rascunhoSalvo = true;
        inicial = rascunho;
      } else {
        inicial = await _criarNova();
      }
    }

    _base = inicial;
    _idade = inicial.idade;
    _sexo = inicial.sexo;
    _fumante = inicial.fumante;
    _diabetico = inicial.diabetico;
    _pressaoSistolica = inicial.pressaoSistolica;
    _usaRemedioPressao = inicial.usaRemedioPressao;
    _colesterolTotal = inicial.colesterolTotal;
    _hdl = inicial.hdl;
    _carregando = false;
    _avisar();
  }

  Future<AvaliacaoModel> _criarNova() async {
    final agora = DateTime.now();
    final profissional = await _armazenamento.obterProfissional();
    return AvaliacaoModel(
      id: agora.microsecondsSinceEpoch.toString(),
      codigoPaciente: await _armazenamento.gerarProximoCodigoPaciente(),
      profissionalId: profissional?.uid ?? '',
      dataHora: agora,
      atualizadoEm: agora,
    );
  }

  // --- Respostas: cada mudança atualiza a tela e agenda o salvamento ---

  void alterarIdade(String texto) {
    _idade = int.tryParse(texto);
    _aoAlterar();
  }

  void alterarSexo(Sexo valor) {
    _sexo = valor;
    _aoAlterar();
  }

  void alterarFumante(bool valor) {
    _fumante = valor;
    _aoAlterar();
  }

  void alterarDiabetico(bool valor) {
    _diabetico = valor;
    _aoAlterar();
  }

  void alterarPressao(String texto) {
    _pressaoSistolica = int.tryParse(texto);
    _aoAlterar();
  }

  void alterarUsaRemedio(bool valor) {
    _usaRemedioPressao = valor;
    _aoAlterar();
  }

  void alterarColesterol(String texto) {
    _colesterolTotal = int.tryParse(texto);
    _aoAlterar();
  }

  void alterarHdl(String texto) {
    _hdl = int.tryParse(texto);
    _aoAlterar();
  }

  // --- Navegação entre as etapas ---

  /// Etapa 1 -> Etapa 2, se os dados pessoais estiverem certos.
  /// Devolve true se avançou.
  bool avancar() {
    _erros = montarAvaliacao().validar(etapa: 1);
    if (_erros.isEmpty) {
      _etapa = 2;
      _agendarSalvamento();
    }
    _avisar();
    return _erros.isEmpty;
  }

  /// Etapa 2 -> Etapa 1, sem perder nada do que foi preenchido.
  void voltar() {
    _etapa = 1;
    _erros = const [];
    _agendarSalvamento();
    _avisar();
  }

  /// Valida tudo e calcula o risco. Devolve a avaliação com o resultado,
  /// ou null se houver erros (que ficam disponíveis em [erros]).
  AvaliacaoModel? avaliar() {
    final avaliacao = montarAvaliacao();
    _erros = avaliacao.validar();
    if (_erros.isNotEmpty) {
      _avisar();
      return null;
    }
    _avisar();
    return avaliacao.copyWith(resultado: calculadora.calcular(avaliacao));
  }

  /// Junta os dados fixos com as respostas atuais em uma AvaliacaoModel.
  AvaliacaoModel montarAvaliacao() {
    final base = _base!;
    return AvaliacaoModel(
      id: base.id,
      codigoPaciente: base.codigoPaciente,
      profissionalId: base.profissionalId,
      dataHora: base.dataHora,
      etapaAtual: _etapa,
      idade: _idade,
      sexo: _sexo,
      fumante: _fumante,
      diabetico: _diabetico,
      pressaoSistolica: _pressaoSistolica,
      usaRemedioPressao: _usaRemedioPressao,
      colesterolTotal: _colesterolTotal,
      hdl: _hdl,
      statusSync: base.statusSync,
      atualizadoEm: DateTime.now(),
    );
  }

  // --- Salvamento automático do rascunho ---

  void _aoAlterar() {
    _erros = const [];
    _rascunhoSalvo = false;
    _avisar();
    _agendarSalvamento();
  }

  /// Espera a pessoa parar de digitar por um instante e então salva
  /// o rascunho no aparelho. Na edição de uma avaliação já salva,
  /// não usa o rascunho.
  void _agendarSalvamento() {
    if (_modoEdicao || _base == null) {
      return;
    }
    _temporizadorSalvamento?.cancel();
    _temporizadorSalvamento =
        Timer(const Duration(milliseconds: 600), _salvarRascunho);
  }

  Future<void> _salvarRascunho() async {
    await _armazenamento.salvarRascunho(montarAvaliacao());
    _rascunhoSalvo = true;
    _avisar();
  }

  void _avisar() {
    if (!_descartado) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Se a tela fechar antes do salvamento agendado, salva na hora.
    if (_temporizadorSalvamento?.isActive ?? false) {
      _temporizadorSalvamento!.cancel();
      _armazenamento.salvarRascunho(montarAvaliacao());
    }
    _descartado = true;
    super.dispose();
  }
}

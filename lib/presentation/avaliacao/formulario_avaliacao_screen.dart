import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/enums_avaliacao.dart';
import 'formulario_avaliacao_controller.dart';
import 'resultado_screen.dart';
import 'widgets/cabecalho_avaliacao.dart';
import 'widgets/campo_numerico.dart';
import 'widgets/indicador_etapas.dart';
import 'widgets/rotulo_campo.dart';
import 'widgets/seletor_duas_opcoes.dart';

/// Telas 1 e 2 do fluxo principal: o formulário de avaliação em 2 etapas
/// (dados pessoais e dados clínicos), com as 7 perguntas.
///
/// - Avaliação nova: `FormularioAvaliacaoScreen()`.
/// - Editar uma avaliação já salva (histórico):
///   `FormularioAvaliacaoScreen(avaliacao: avaliacaoExistente)`.
class FormularioAvaliacaoScreen extends StatelessWidget {
  const FormularioAvaliacaoScreen({super.key, this.avaliacao});

  final AvaliacaoModel? avaliacao;

  @override
  Widget build(BuildContext context) {
    // Cria o controlador e o deixa disponível para a tela abaixo.
    // O Provider também chama dispose() quando a tela fecha.
    return ChangeNotifierProvider(
      create: (_) => FormularioAvaliacaoController(),
      child: _FormularioView(avaliacao: avaliacao),
    );
  }
}

class _FormularioView extends StatefulWidget {
  const _FormularioView({this.avaliacao});

  final AvaliacaoModel? avaliacao;

  @override
  State<_FormularioView> createState() => _FormularioViewState();
}

class _FormularioViewState extends State<_FormularioView> {
  // Guardam o texto digitado em cada campo numérico.
  final _idade = TextEditingController();
  final _pressao = TextEditingController();
  final _colesterol = TextEditingController();
  final _hdl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  /// Inicia o controlador e preenche os campos com o que já existia
  /// (rascunho salvo ou avaliação em edição).
  Future<void> _carregar() async {
    final form = context.read<FormularioAvaliacaoController>();
    await form.iniciar(avaliacaoExistente: widget.avaliacao);
    if (!mounted) {
      return;
    }
    _preencherCampos(form);
  }

  /// Coloca nos campos de texto os números que estão no controlador.
  void _preencherCampos(FormularioAvaliacaoController form) {
    _idade.text = form.idade?.toString() ?? '';
    _pressao.text = form.pressaoSistolica?.toString() ?? '';
    _colesterol.text = form.colesterolTotal?.toString() ?? '';
    _hdl.text = form.hdl?.toString() ?? '';
  }

  @override
  void dispose() {
    _idade.dispose();
    _pressao.dispose();
    _colesterol.dispose();
    _hdl.dispose();
    super.dispose();
  }

  void _continuar(FormularioAvaliacaoController form) {
    FocusScope.of(context).unfocus();
    form.avancar();
  }

  Future<void> _avaliar(FormularioAvaliacaoController form) async {
    FocusScope.of(context).unfocus();
    final avaliacao = form.avaliar();
    if (avaliacao == null) {
      return;
    }
    // Abre a Tela 3. O formulário continua aberto por baixo, então o
    // botão de voltar da Tela 3 permite corrigir alguma resposta.
    final concluiu = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ResultadoScreen(avaliacao: avaliacao),
      ),
    );
    if (concluiu != true || !mounted) {
      return;
    }
    // A avaliação foi concluída na Tela 4.
    final navegador = Navigator.of(context);
    if (navegador.canPop()) {
      // Volta para a tela que abriu o formulário (home ou histórico).
      navegador.pop(true);
    } else {
      // O formulário é a primeira tela (main de desenvolvimento):
      // começa uma avaliação nova.
      await form.novaAvaliacao();
      if (mounted) {
        _preencherCampos(form);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // watch: redesenha esta tela sempre que o controlador mudar.
    final form = context.watch<FormularioAvaliacaoController>();

    if (form.carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final etapa1 = form.etapa == 1;
    final navegador = Navigator.of(context);

    // Na etapa 2, o botão "voltar" do celular volta para a etapa 1
    // em vez de fechar o formulário.
    return PopScope(
      canPop: etapa1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          form.voltar();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              // Seta de voltar: na etapa 2 volta para a etapa 1; na etapa 1
              // volta para a tela anterior (se existir uma).
              CabecalhoAvaliacao(
                aoVoltar: !etapa1
                    ? form.voltar
                    : navegador.canPop()
                        ? () => navegador.maybePop()
                        : null,
              ),
              const SizedBox(height: 20),
              IndicadorEtapas(etapaAtual: form.etapa),
              const SizedBox(height: 16),
              Text(
                etapa1 ? 'Dados pessoais' : 'Dados clínicos',
                style: const TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                etapa1
                    ? 'Informe algumas informações sobre você.'
                    : 'Informe os valores medidos durante a avaliação.',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                ),
              ),
              if (form.modoEdicao)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Editando uma avaliação já salva',
                    style: TextStyle(color: AppTheme.warningYellow),
                  ),
                ),
              const SizedBox(height: 16),
              if (etapa1) ...[
                _ChipCodigoPaciente(codigo: form.codigoPaciente),
                const SizedBox(height: 20),
                ..._perguntasEtapa1(form),
              ] else
                ..._perguntasEtapa2(form),
              if (form.erros.isNotEmpty) ...[
                const SizedBox(height: 20),
                _CaixaErros(erros: form.erros),
              ],
              const SizedBox(height: 24),
              if (etapa1)
                ElevatedButton(
                  onPressed: () => _continuar(form),
                  child: const Text('CONTINUAR →'),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: form.voltar,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          foregroundColor: AppTheme.textSecondary,
                          side: const BorderSide(color: AppTheme.surfaceVariant),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('← VOLTAR'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => _avaliar(form),
                        child: const Text('AVALIAR RISCO'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (etapa1) ...[
                const _Nota(
                  icone: Icons.info_outline,
                  cor: AppTheme.textSecondary,
                  texto: 'Essas informações nos ajudam a calcular seu risco '
                      'cardiovascular.',
                ),
                const SizedBox(height: 10),
                const _Nota(
                  icone: Icons.shield_outlined,
                  cor: AppTheme.primaryGreen,
                  texto: 'Seus dados são protegidos e utilizados apenas para '
                      'fins de avaliação de risco.',
                ),
                const SizedBox(height: 16),
              ],
              _AvisoSalvamento(
                modoEdicao: form.modoEdicao,
                salvo: form.rascunhoSalvo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Etapa 1: perguntas 1 a 4.
  List<Widget> _perguntasEtapa1(FormularioAvaliacaoController form) {
    final sexo = form.sexo;
    return [
      const RotuloCampo('1. Idade', icone: Icons.person_outline),
      CampoNumerico(
        controller: _idade,
        onChanged: form.alterarIdade,
        sufixo: 'anos',
        exemplo: 'Ex.: 56',
        ajuda: 'Entre 30 e 74 anos (faixa em que o escore é válido).',
        acao: TextInputAction.done,
      ),
      const SizedBox(height: 20),
      const RotuloCampo('2. Sexo', icone: Icons.people_outline),
      SeletorDuasOpcoes(
        opcaoA: Sexo.masculino.rotulo,
        opcaoB: Sexo.feminino.rotulo,
        selecionado: sexo == null ? null : sexo == Sexo.masculino,
        onChanged: (masculino) =>
            form.alterarSexo(masculino ? Sexo.masculino : Sexo.feminino),
      ),
      const SizedBox(height: 20),
      const RotuloCampo('3. Tabagismo', icone: Icons.air),
      SeletorDuasOpcoes(
        opcaoA: 'Sim',
        opcaoB: 'Não',
        selecionado: form.fumante,
        onChanged: form.alterarFumante,
      ),
      const SizedBox(height: 20),
      const RotuloCampo('4. Diabetes', icone: Icons.monitor_heart_outlined),
      SeletorDuasOpcoes(
        opcaoA: 'Sim',
        opcaoB: 'Não',
        selecionado: form.diabetico,
        onChanged: form.alterarDiabetico,
      ),
    ];
  }

  /// Etapa 2: pressão (com a pergunta do remédio), colesterol total e HDL.
  List<Widget> _perguntasEtapa2(FormularioAvaliacaoController form) {
    return [
      const RotuloCampo('Pressão arterial sistólica'),
      CampoNumerico(
        controller: _pressao,
        onChanged: form.alterarPressao,
        sufixo: 'mmHg',
        exemplo: 'Ex.: 140',
        icone: Icons.monitor_heart_outlined,
        ajuda: 'Valor da pressão no momento da contração do coração '
            '(o número maior: "14 por 9" = 140).',
      ),
      const SizedBox(height: 16),
      const RotuloCampo('Usa remédio para controlar a pressão?'),
      SeletorDuasOpcoes(
        opcaoA: 'Sim',
        opcaoB: 'Não',
        selecionado: form.usaRemedioPressao,
        onChanged: form.alterarUsaRemedio,
      ),
      const SizedBox(height: 20),
      const RotuloCampo('Colesterol total'),
      CampoNumerico(
        controller: _colesterol,
        onChanged: form.alterarColesterol,
        sufixo: 'mg/dL',
        exemplo: 'Ex.: 210',
        icone: Icons.water_drop_outlined,
        ajuda: 'Informe o valor apresentado no seu exame mais recente.',
      ),
      const SizedBox(height: 20),
      const RotuloCampo('HDL (colesterol bom)'),
      CampoNumerico(
        controller: _hdl,
        onChanged: form.alterarHdl,
        sufixo: 'mg/dL',
        exemplo: 'Ex.: 45',
        icone: Icons.shield_outlined,
        ajuda: 'Ajuda a proteger o coração.',
        acao: TextInputAction.done,
      ),
      const SizedBox(height: 20),
      const _CaixaDica(
        texto: 'Use os resultados mais recentes dos seus exames.',
      ),
    ];
  }
}

/// Mostra o código anônimo do paciente (nunca nome ou CPF).
class _ChipCodigoPaciente extends StatelessWidget {
  const _ChipCodigoPaciente({required this.codigo});

  final String codigo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surfaceVariant),
      ),
      child: Row(
        children: [
          const Icon(Icons.tag, size: 18, color: AppTheme.primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Código do paciente: $codigo (sem nome ou CPF)',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista os erros de validação em uma caixa vermelha.
class _CaixaErros extends StatelessWidget {
  const _CaixaErros({required this.erros});

  final List<String> erros;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.dangerRed.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.dangerRed),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final erro in erros)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 18, color: AppTheme.dangerRed),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        erro,
                        style: const TextStyle(color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Frase curta com ícone, usada no rodapé da etapa 1.
class _Nota extends StatelessWidget {
  const _Nota({required this.icone, required this.cor, required this.texto});

  final IconData icone;
  final Color cor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, color: cor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

/// Caixa azulada com uma dica, usada antes dos botões da etapa 2.
class _CaixaDica extends StatelessWidget {
  const _CaixaDica({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2A3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2B3F55)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.help_outline, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(texto, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

/// Avisa que o preenchimento fica salvo no aparelho.
class _AvisoSalvamento extends StatelessWidget {
  const _AvisoSalvamento({required this.modoEdicao, required this.salvo});

  final bool modoEdicao;
  final bool salvo;

  @override
  Widget build(BuildContext context) {
    final String texto;
    if (modoEdicao) {
      texto = 'As alterações só valem quando a avaliação for concluída.';
    } else if (salvo) {
      texto = 'Rascunho salvo neste aparelho. Se o app fechar, nada se perde.';
    } else {
      texto = 'O preenchimento é salvo automaticamente neste aparelho.';
    }
    return Row(
      children: [
        Icon(
          salvo && !modoEdicao ? Icons.check_circle_outline : Icons.save_outlined,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

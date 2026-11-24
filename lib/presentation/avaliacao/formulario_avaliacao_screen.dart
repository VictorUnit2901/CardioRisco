import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/enums_avaliacao.dart';
import 'formulario_avaliacao_controller.dart';
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

  void _avaliar(FormularioAvaliacaoController form) {
    FocusScope.of(context).unfocus();
    final avaliacao = form.avaliar();
    final resultado = avaliacao?.resultado;
    if (resultado == null) {
      return;
    }
    // PROVISÓRIO: quando a Tela 3 (velocímetro) existir, esta mensagem
    // será trocada pela navegação para ela.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Risco em 10 anos: ${resultado.percentualFormatado()} '
          '(${resultado.nivel.rotulo}) - ${resultado.modelo}',
        ),
      ),
    );
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

    // Na etapa 2, o botão "voltar" do celular volta para a etapa 1
    // em vez de fechar o formulário.
    return PopScope(
      canPop: form.etapa == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          form.voltar();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.background,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite, color: AppTheme.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'CardioRisco',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              IndicadorEtapas(etapaAtual: form.etapa),
              const SizedBox(height: 16),
              Text(
                form.etapa == 1 ? 'Dados pessoais' : 'Dados clínicos',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (form.modoEdicao)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Editando uma avaliação já salva',
                    style: TextStyle(color: AppTheme.warningYellow),
                  ),
                ),
              const SizedBox(height: 12),
              _ChipCodigoPaciente(codigo: form.codigoPaciente),
              const SizedBox(height: 24),
              if (form.etapa == 1)
                ..._perguntasEtapa1(form)
              else
                ..._perguntasEtapa2(form),
              if (form.erros.isNotEmpty) ...[
                const SizedBox(height: 20),
                _CaixaErros(erros: form.erros),
              ],
              const SizedBox(height: 24),
              if (form.etapa == 1)
                ElevatedButton(
                  onPressed: () => _continuar(form),
                  child: const Text('CONTINUAR'),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: form.voltar,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          foregroundColor: AppTheme.textPrimary,
                          side: const BorderSide(color: AppTheme.surfaceVariant),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('VOLTAR'),
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
              const SizedBox(height: 16),
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
      const RotuloCampo('1. Idade', dica: 'Entre 30 e 74 anos'),
      CampoNumerico(
        controller: _idade,
        onChanged: form.alterarIdade,
        sufixo: 'anos',
        exemplo: 'Ex.: 56',
        acao: TextInputAction.done,
      ),
      const SizedBox(height: 20),
      const RotuloCampo('2. Sexo'),
      SeletorDuasOpcoes(
        opcaoA: Sexo.masculino.rotulo,
        opcaoB: Sexo.feminino.rotulo,
        selecionado: sexo == null ? null : sexo == Sexo.masculino,
        onChanged: (masculino) =>
            form.alterarSexo(masculino ? Sexo.masculino : Sexo.feminino),
      ),
      const SizedBox(height: 20),
      const RotuloCampo('3. Fuma atualmente?'),
      SeletorDuasOpcoes(
        opcaoA: 'Sim',
        opcaoB: 'Não',
        selecionado: form.fumante,
        onChanged: form.alterarFumante,
      ),
      const SizedBox(height: 20),
      const RotuloCampo('4. Tem diabetes?'),
      SeletorDuasOpcoes(
        opcaoA: 'Sim',
        opcaoB: 'Não',
        selecionado: form.diabetico,
        onChanged: form.alterarDiabetico,
      ),
    ];
  }

  /// Etapa 2: perguntas 5 a 7 (o remédio para pressão faz parte da 5).
  List<Widget> _perguntasEtapa2(FormularioAvaliacaoController form) {
    return [
      const RotuloCampo(
        '5. Pressão arterial sistólica',
        dica: 'O número maior da medida. Ex.: "14 por 9" = 140',
      ),
      CampoNumerico(
        controller: _pressao,
        onChanged: form.alterarPressao,
        sufixo: 'mmHg',
        exemplo: 'Ex.: 140',
      ),
      const SizedBox(height: 12),
      const Text(
        'Usa remédio para controlar a pressão?',
        style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
      ),
      const SizedBox(height: 8),
      SeletorDuasOpcoes(
        opcaoA: 'Sim',
        opcaoB: 'Não',
        selecionado: form.usaRemedioPressao,
        onChanged: form.alterarUsaRemedio,
      ),
      const SizedBox(height: 20),
      const RotuloCampo('6. Colesterol total', dica: 'Do exame de sangue'),
      CampoNumerico(
        controller: _colesterol,
        onChanged: form.alterarColesterol,
        sufixo: 'mg/dL',
        exemplo: 'Ex.: 210',
      ),
      const SizedBox(height: 20),
      const RotuloCampo('7. HDL', dica: 'O colesterol "bom", do mesmo exame'),
      CampoNumerico(
        controller: _hdl,
        onChanged: form.alterarHdl,
        sufixo: 'mg/dL',
        exemplo: 'Ex.: 45',
        acao: TextInputAction.done,
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.surfaceVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline,
                size: 16, color: AppTheme.textSecondary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Código do paciente: $codigo (sem nome ou CPF)',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
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

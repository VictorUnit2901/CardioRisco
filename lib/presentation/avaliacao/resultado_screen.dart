import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/avaliacao_model.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../../domain/models/fator_risco.dart';
import '../../domain/models/resultado_risco.dart';
import '../../domain/services/calculadora_erg_sbc.dart';
import '../../domain/services/identificador_fatores.dart';
import 'recomendacoes_screen.dart';
import 'widgets/cabecalho_avaliacao.dart';
import 'widgets/estilo_risco.dart';
import 'widgets/velocimetro.dart';

/// Tela 3 do fluxo principal: o resultado da avaliação, com o
/// velocímetro, o percentual, a classificação e os fatores de risco.
///
/// Recebe a avaliação já calculada (com [AvaliacaoModel.resultado]).
class ResultadoScreen extends StatelessWidget {
  const ResultadoScreen({super.key, required this.avaliacao});

  final AvaliacaoModel avaliacao;

  @override
  Widget build(BuildContext context) {
    final resultado = avaliacao.resultado;
    final sexo = avaliacao.sexo;
    if (resultado == null || sexo == null) {
      return const Scaffold(
        body: Center(child: Text('Esta avaliação ainda não tem resultado.')),
      );
    }

    final nivel = resultado.nivel;
    final fatores = const IdentificadorFatores().identificar(avaliacao);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CabecalhoAvaliacao(aoVoltar: () => Navigator.of(context).pop()),
              const SizedBox(height: 24),
              const Text(
                'SEU RESULTADO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Velocimetro(
                  percentual: resultado.percentual,
                  sexo: sexo,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                resultado.percentualFormatado(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: nivel.cor,
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'Risco cardiovascular em 10 anos',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Center(child: _SeloNivel(nivel: nivel)),
              const SizedBox(height: 20),
              _CartaoExplicacao(nivel: nivel),
              const SizedBox(height: 24),
              const Text(
                'O que influencia seu risco?',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (fatores.isEmpty)
                const _SemFatores()
              else
                for (final fator in fatores) _ItemFator(fator: fator),
              const SizedBox(height: 16),
              _CartaoOutroModelo(avaliacao: avaliacao),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _verOrientacoes(context),
                child: const Text('VER ORIENTAÇÕES →'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _mostrarComoCalcula(context, resultado, sexo),
                child: const Text(
                  'SAIBA MAIS SOBRE O CÁLCULO',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const _NotaRodape(),
            ],
          ),
        ),
      ),
    );
  }

  /// Abre a Tela 4. Se a avaliação for concluída lá, esta tela também
  /// fecha, avisando o formulário com `true`.
  Future<void> _verOrientacoes(BuildContext context) async {
    final concluiu = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RecomendacoesScreen(avaliacao: avaliacao),
      ),
    );
    if (concluiu == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  /// Explica de onde vem o número, para o profissional poder
  /// justificar o resultado ao paciente.
  void _mostrarComoCalcula(
    BuildContext context,
    ResultadoRisco resultado,
    Sexo sexo,
  ) {
    final limiteAlto = ResultadoRisco.limiteAlto(sexo).round();
    final publico = sexo == Sexo.masculino ? 'homens' : 'mulheres';
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Como o risco é calculado',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Modelo usado: ${resultado.modelo}',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              const Text(
                "A equação de Framingham (D'Agostino e colaboradores, 2008) "
                'é a base do Escore de Risco Global usado pela Sociedade '
                'Brasileira de Cardiologia. Ela combina idade, sexo, '
                'colesterol total, HDL, pressão sistólica (com ou sem '
                'remédio), tabagismo e diabetes para estimar a chance de '
                'um infarto, AVC ou outro evento cardiovascular nos '
                'próximos 10 anos.',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 12),
              const Text(
                'O app também calcula pela tabela de pontos do Escore de '
                'Risco Global (a versão em papel usada nas UBS) e mostra o '
                'resultado para comparação. Como a tabela arredonda os '
                'valores, os dois números podem ser um pouco diferentes.',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 16),
              Text(
                'Faixas da SBC para $publico',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const _LinhaFaixa(
                nivel: NivelRisco.baixo,
                texto: 'Baixo: menor que 5%',
              ),
              _LinhaFaixa(
                nivel: NivelRisco.intermediario,
                texto: 'Intermediário: de 5% a $limiteAlto%',
              ),
              _LinhaFaixa(
                nivel: NivelRisco.alto,
                texto: 'Alto: maior que $limiteAlto%',
              ),
              const SizedBox(height: 16),
              const Text(
                'O resultado é uma estimativa e não substitui a avaliação '
                'de um profissional de saúde.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selo colorido com o nível de risco (ex.: "RISCO INTERMEDIÁRIO").
class _SeloNivel extends StatelessWidget {
  const _SeloNivel({required this.nivel});

  final NivelRisco nivel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: nivel.cor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(nivel.icone, color: AppTheme.background, size: 22),
          const SizedBox(width: 8),
          Text(
            'RISCO ${nivel.rotulo.toUpperCase()}',
            style: const TextStyle(
              color: AppTheme.background,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Resultado do segundo modelo (tabela de pontos do ERG/SBC), para
/// comparar com a equação de Framingham do velocímetro.
class _CartaoOutroModelo extends StatelessWidget {
  const _CartaoOutroModelo({required this.avaliacao});

  final AvaliacaoModel avaliacao;

  @override
  Widget build(BuildContext context) {
    ResultadoRisco? erg;
    try {
      erg = const CalculadoraErgSbc().calcular(avaliacao);
    } on ArgumentError {
      erg = null;
    }
    if (erg == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.compare_arrows, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pela tabela de pontos da SBC',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: CalculadoraErgSbc.formatarPercentual(
                          erg.percentual,
                        ),
                        style: TextStyle(
                          color: erg.nivel.cor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' · risco ${erg.nivel.rotulo.toLowerCase()}',
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 4),
                const Text(
                  'O velocímetro usa a equação de Framingham, que é mais '
                  'precisa. A tabela de pontos é a versão em papel do mesmo '
                  'escore e pode dar um valor um pouco diferente.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Caixa com a explicação do nível em linguagem simples.
class _CartaoExplicacao extends StatelessWidget {
  const _CartaoExplicacao({required this.nivel});

  final NivelRisco nivel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: nivel.cor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: nivel.cor.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(nivel.icone, color: nivel.cor, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              nivel.descricao,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Um fator de risco da lista. Ao tocar, mostra a explicação.
class _ItemFator extends StatelessWidget {
  const _ItemFator({required this.fator});

  final FatorRisco fator;

  @override
  Widget build(BuildContext context) {
    final borda = BorderRadius.circular(12);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppTheme.surface,
        borderRadius: borda,
        child: InkWell(
          borderRadius: borda,
          onTap: () => _mostrarExplicacao(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: borda,
              border: Border.all(color: AppTheme.surfaceVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: fator.cor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(fator.icone, color: fator.cor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    fator.titulo,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarExplicacao(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(fator.icone, color: fator.cor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      fator.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                fator.explicacao,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mostrado quando nenhuma resposta está alterada.
class _SemFatores extends StatelessWidget {
  const _SemFatores();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceVariant),
      ),
      child: const Text(
        'Nenhuma das respostas está fora do recomendado. Mantenha os '
        'hábitos saudáveis e as consultas de rotina.',
        style: TextStyle(fontSize: 15, height: 1.4),
      ),
    );
  }
}

/// Uma linha da explicação das faixas, com a bolinha da cor do nível.
class _LinhaFaixa extends StatelessWidget {
  const _LinhaFaixa({required this.nivel, required this.texto});

  final NivelRisco nivel;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.circle, size: 12, color: nivel.cor),
          const SizedBox(width: 10),
          Text(texto, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

/// Aviso de que o app não substitui o profissional de saúde.
class _NotaRodape extends StatelessWidget {
  const _NotaRodape();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: AppTheme.textSecondary, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Resultado estimado pelo Escore de Risco Global (SBC/Framingham). '
            'Não substitui a avaliação de um profissional de saúde.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

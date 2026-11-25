import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/models/enums_avaliacao.dart';
import '../../../domain/models/resultado_risco.dart';

/// Velocímetro da Tela 3: um meio círculo com as faixas verde (baixo),
/// amarela (intermediário) e vermelha (alto), e um ponteiro que gira
/// até o percentual de risco.
class Velocimetro extends StatelessWidget {
  const Velocimetro({
    super.key,
    required this.percentual,
    required this.sexo,
    this.largura = 260,
  });

  /// Risco em 10 anos, de 0 a 100 (%).
  final double percentual;

  /// As faixas da SBC mudam conforme o sexo.
  final Sexo sexo;

  final double largura;

  /// Converte o percentual na posição do ponteiro no arco:
  /// 0 = começo (esquerda) e 1 = fim (direita).
  ///
  /// Cada faixa ocupa 1/3 do arco, para o ponteiro sempre cair na cor
  /// certa. Para homens: 0-5% no verde, 5-20% no amarelo e 20-40% no
  /// vermelho. Para mulheres: 0-5%, 5-10% e 10-20%. Acima disso, o
  /// ponteiro fica no fim do arco.
  static double posicaoNoArco(double percentual, Sexo sexo) {
    const limiteBaixo = ResultadoRisco.limiteBaixo;
    final limiteAlto = ResultadoRisco.limiteAlto(sexo);
    final fimDaEscala = limiteAlto * 2;

    final double dentroDaFaixa;
    final int faixa;
    if (percentual < limiteBaixo) {
      faixa = 0;
      dentroDaFaixa = percentual / limiteBaixo;
    } else if (percentual <= limiteAlto) {
      faixa = 1;
      dentroDaFaixa = (percentual - limiteBaixo) / (limiteAlto - limiteBaixo);
    } else {
      faixa = 2;
      dentroDaFaixa = (percentual - limiteAlto) / (fimDaEscala - limiteAlto);
    }
    final posicao = (faixa + dentroDaFaixa.clamp(0.0, 1.0)) / 3;
    return posicao.clamp(0.0, 1.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final destino = posicaoNoArco(percentual, sexo);
    return Semantics(
      label: 'Velocímetro de risco: ${percentual.round()}% em 10 anos',
      child: ExcludeSemantics(
        // Anima o ponteiro do começo do arco até a posição final.
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: destino),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, posicao, _) => CustomPaint(
            size: Size(largura, largura / 2 + 12),
            painter: _PintorVelocimetro(posicao: posicao),
          ),
        ),
      ),
    );
  }
}

/// Desenha o velocímetro no Canvas. No Canvas, o ângulo 0 aponta para a
/// direita e cresce no sentido horário; por isso o arco vai de pi
/// (esquerda) até 2*pi (direita), passando pelo topo.
class _PintorVelocimetro extends CustomPainter {
  _PintorVelocimetro({required this.posicao});

  final double posicao;

  static const _cores = [
    AppTheme.primaryGreen,
    AppTheme.warningYellow,
    AppTheme.dangerRed,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final espessura = size.width * 0.13;
    final raio = (size.width - espessura) / 2;
    final centro = Offset(size.width / 2, raio + espessura / 2);
    final area = Rect.fromCircle(center: centro, radius: raio);

    // As 3 faixas coloridas, com um pequeno espaço entre elas.
    const espaco = 0.03;
    for (var i = 0; i < _cores.length; i++) {
      final pincel = Paint()
        ..color = _cores[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = espessura;
      final inicio = pi + i * pi / 3;
      canvas.drawArc(area, inicio + espaco / 2, pi / 3 - espaco, false, pincel);
    }

    // O ponteiro e o círculo do centro.
    final angulo = pi + posicao * pi;
    final ponta = centro + Offset(cos(angulo), sin(angulo)) * (raio * 0.85);
    final pincelPonteiro = Paint()
      ..color = AppTheme.textPrimary
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(centro, ponta, pincelPonteiro);
    canvas.drawCircle(centro, 10, Paint()..color = AppTheme.textPrimary);
  }

  @override
  bool shouldRepaint(_PintorVelocimetro antigo) => antigo.posicao != posicao;
}

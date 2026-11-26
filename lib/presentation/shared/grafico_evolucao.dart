import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatadores.dart';
import '../../domain/models/enums_avaliacao.dart';
import '../../domain/models/resultado_risco.dart';
import 'cores_risco.dart';

/// Um ponto do gráfico: uma avaliação no tempo.
class PontoEvolucao {
  const PontoEvolucao(this.data, this.valor, this.nivel);
  final DateTime data;
  final double valor;
  final NivelRisco nivel;
}

/// Linha do risco (%) ao longo do tempo, com eixos e as faixas da SBC.
/// [limiteAlto] é 20 para homens e 10 para mulheres.
class GraficoEvolucao extends StatelessWidget {
  const GraficoEvolucao({
    super.key,
    required this.pontos,
    required this.limiteAlto,
    this.altura = 280,
  });

  final List<PontoEvolucao> pontos;
  final double limiteAlto;
  final double altura;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: altura,
      width: double.infinity,
      child: CustomPaint(
        painter: _EvolucaoPainter(pontos, limiteAlto),
      ),
    );
  }
}

class _EvolucaoPainter extends CustomPainter {
  _EvolucaoPainter(this.pontos, this.limiteAlto);
  final List<PontoEvolucao> pontos;
  final double limiteAlto;

  void _texto(Canvas c, String t, Offset o,
      {Color cor = AppTheme.textSecondary,
      double tamanho = 11,
      bool centro = false,
      bool direita = false}) {
    final tp = TextPainter(
      text: TextSpan(text: t, style: TextStyle(color: cor, fontSize: tamanho)),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = o.dx;
    if (centro) dx -= tp.width / 2;
    if (direita) dx -= tp.width;
    tp.paint(c, Offset(dx, o.dy - tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    const esq = 44.0, dir = 20.0, topo = 20.0, base = 30.0;
    final w = size.width - esq - dir;
    final h = size.height - topo - base;
    if (w <= 0 || h <= 0) return;

    final maiorValor =
        pontos.isEmpty ? 0.0 : pontos.map((p) => p.valor).reduce(math.max);
    final maxY = math.max(limiteAlto * 1.3, maiorValor * 1.15);
    double yDe(double v) => topo + h - (v / maxY) * h;
    double xDe(int i) =>
        pontos.length == 1 ? esq + w / 2 : esq + w * i / (pontos.length - 1);

    // Faixas de risco ao fundo: verde / amarelo / vermelho.
    void faixa(double de, double ate, Color cor) {
      canvas.drawRect(
        Rect.fromLTRB(esq, yDe(ate), esq + w, yDe(de)),
        Paint()..color = cor.withValues(alpha: 0.08),
      );
    }

    faixa(0, ResultadoRisco.limiteBaixo, AppTheme.primaryGreen);
    faixa(ResultadoRisco.limiteBaixo, limiteAlto, AppTheme.warningYellow);
    faixa(limiteAlto, maxY, AppTheme.dangerRed);

    // Linhas de referência com o valor no eixo Y.
    final grade = Paint()
      ..color = AppTheme.textSecondary.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    for (final v in <double>[0, ResultadoRisco.limiteBaixo, limiteAlto]) {
      canvas.drawLine(Offset(esq, yDe(v)), Offset(esq + w, yDe(v)), grade);
      _texto(canvas, '${v.round()}%', Offset(esq - 6, yDe(v)), direita: true);
    }
    _texto(canvas, 'Alto', Offset(esq + w - 2, yDe(limiteAlto) - 8),
        cor: AppTheme.dangerRed, tamanho: 10, direita: true);

    if (pontos.isEmpty) return;

    // Linha ligando as avaliações.
    final linha = Paint()
      ..color = AppTheme.textPrimary.withValues(alpha: 0.8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final caminho = Path();
    for (var i = 0; i < pontos.length; i++) {
      final p = Offset(xDe(i), yDe(pontos[i].valor));
      i == 0 ? caminho.moveTo(p.dx, p.dy) : caminho.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(caminho, linha);

    // Pontos coloridos pelo nível, com o valor em cima e a data embaixo.
    final passoRotulo = (pontos.length / 6).ceil();
    for (var i = 0; i < pontos.length; i++) {
      final p = Offset(xDe(i), yDe(pontos[i].valor));
      canvas.drawCircle(p, 6, Paint()..color = AppTheme.background);
      canvas.drawCircle(p, 5, Paint()..color = corDoNivel(pontos[i].nivel));
      _texto(canvas, formatarPercentual(pontos[i].valor), p.translate(0, -14),
          cor: AppTheme.textPrimary, tamanho: 11, centro: true);
      if (i % passoRotulo == 0 || i == pontos.length - 1) {
        _texto(canvas, formatarDiaMes(pontos[i].data),
            Offset(xDe(i), size.height - base / 2 + 4),
            centro: true, tamanho: 10);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _EvolucaoPainter old) =>
      old.limiteAlto != limiteAlto || !listEquals(old.pontos, pontos);
}

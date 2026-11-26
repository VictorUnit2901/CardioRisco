import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Gráfico de rosca com legenda. Cada fatia tem rótulo, valor e cor própria.
class GraficoRosca extends StatelessWidget {
  const GraficoRosca({
    super.key,
    required this.titulo,
    required this.valores,
    required this.rotulos,
    required this.cores,
  });

  final String titulo;
  final List<double> valores;
  final List<String> rotulos;
  final List<Color> cores;

  @override
  Widget build(BuildContext context) {
    final total = valores.fold<double>(0, (a, b) => a + b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 124,
                  height: 124,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(124, 124),
                        painter: _RoscaPainter(valores, cores),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(total.round().toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const Text('pacientes',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < valores.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: cores[i],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${rotulos[i]}: '
                                  '${total == 0 ? 0 : (valores[i] / total * 100).round()}%'
                                  ' (${valores[i].round()})',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoscaPainter extends CustomPainter {
  _RoscaPainter(this.valores, this.cores);
  final List<double> valores;
  final List<Color> cores;

  static const _espessura = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Recua o retângulo pela metade da espessura, senão o traço é cortado.
    final rect = (Offset.zero & size).deflate(_espessura / 2);
    final pincel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _espessura;
    final total = valores.fold<double>(0, (a, b) => a + b);

    if (total == 0) {
      pincel.color = AppTheme.surfaceVariant;
      canvas.drawArc(rect, 0, math.pi * 2, false, pincel);
      return;
    }

    var inicio = -math.pi / 2;
    for (var i = 0; i < valores.length; i++) {
      if (valores[i] <= 0) continue;
      final varredura = valores[i] / total * math.pi * 2;
      pincel.color = cores[i];
      canvas.drawArc(rect, inicio, varredura, false, pincel);
      inicio += varredura;
    }
  }

  @override
  bool shouldRepaint(covariant _RoscaPainter old) =>
      !listEquals(old.valores, valores) || !listEquals(old.cores, cores);
}

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Um número em destaque com legenda (ex.: "12" / "Avaliações").
class Metrica {
  const Metrica(this.rotulo, this.valor, this.icone, {this.cor});
  final String rotulo;
  final String valor;
  final IconData icone;
  final Color? cor;
}

/// Linha de cartões de métrica, todos com a mesma largura.
class MetricGrid extends StatelessWidget {
  const MetricGrid({super.key, required this.itens});
  final List<Metrica> itens;

  @override
  Widget build(BuildContext context) {
    // Dentro de um ListView a altura é ilimitada, e o "stretch" exige altura
    // limitada. O IntrinsicHeight resolve: todos os cartões ficam com a
    // altura do maior.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < itens.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _MetricaCard(itens[i])),
          ],
        ],
      ),
    );
  }
}

class _MetricaCard extends StatelessWidget {
  const _MetricaCard(this.m);
  final Metrica m;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(m.icone, color: m.cor ?? AppTheme.primaryGreen),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                m.valor,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              m.rotulo,
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class TituloSecao extends StatelessWidget {
  const TituloSecao(this.texto, {super.key});
  final String texto;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Text(texto, style: Theme.of(context).textTheme.titleLarge),
      );
}

class LinhaInfo extends StatelessWidget {
  const LinhaInfo(this.rotulo, this.valor, {super.key});
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          dense: true,
          title: Text(rotulo),
          trailing: Text(valor,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
}

class AtalhoTile extends StatelessWidget {
  const AtalhoTile({
    super.key,
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Icon(icone, color: AppTheme.primaryGreen),
          title: Text(titulo),
          subtitle: Text(subtitulo),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}

/// Mensagem para telas sem dados.
class EstadoVazio extends StatelessWidget {
  const EstadoVazio(this.mensagem, {super.key, this.icone = Icons.inbox_outlined});
  final String mensagem;
  final IconData icone;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icone, size: 48, color: AppTheme.textSecondary),
              const SizedBox(height: 12),
              Text(mensagem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textSecondary)),
            ],
          ),
        ),
      );
}

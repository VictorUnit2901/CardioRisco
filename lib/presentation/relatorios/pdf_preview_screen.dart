import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

/// Mostra o PDF na tela, com botões de compartilhar e imprimir.
class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({
    super.key,
    required this.titulo,
    required this.nomeArquivo,
    required this.gerar,
  });

  final String titulo;
  final String nomeArquivo;

  /// Gera os bytes do PDF (chamado quando a tela abre).
  final Future<Uint8List> Function() gerar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: PdfPreview(
        build: (_) => gerar(),
        pdfFileName: nomeArquivo,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        onError: (context, error) => const Center(
          child: Text('Não foi possível gerar o PDF.'),
        ),
      ),
    );
  }
}

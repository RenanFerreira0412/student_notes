import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:student_notes/Widgets/widgets.dart';

class PdfPreviewPage extends StatelessWidget {
  final String? titulo;
  final String? topicos;
  final String? disciplina;
  final String? data;

  const PdfPreviewPage(
      {Key? key,
      required this.titulo,
      required this.topicos,
      required this.disciplina,
      required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prévia do PDF'),
      ),
      body: PdfPreview(
        build: (context) => gerarPDF(titulo!, topicos, disciplina, data),
      ),
    );
  }
}

Future<Uint8List> gerarPDF(String titulo, topicos, disciplina, data) async {
  final pdf = pw.Document();

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
            child: conteudoPDF(titulo, topicos, disciplina, data));
      }));

  return await pdf.save();
}

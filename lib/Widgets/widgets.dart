import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';
import 'package:student_notes/Theme/colors.dart';
import 'package:pdf/widgets.dart' as pw;

class ListTileOptions extends StatelessWidget {
  final IconData icone;
  final String title;
  final VoidCallback onTap;

  const ListTileOptions(
      {Key? key, required this.icone, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ListTile(leading: Icon(icone), title: Text(title), onTap: onTap);
}

class GridBuilder extends StatefulWidget {
  const GridBuilder({Key? key, required this.data, required this.userId})
      : super(key: key);

  final QuerySnapshot data;
  final String userId;

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  late int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    kIsWeb ? crossAxisCount = 3 : crossAxisCount = 2;

    return GridView.builder(
        itemCount: widget.data.size,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount),
        itemBuilder: (BuildContext context, int index) {
          final nomeDisciplina = widget.data.docs[index]['nome'];

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/listActivity',
                  arguments:
                      DisciplinaArguments(nomeDisciplina, widget.userId));
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridTile(
                  header: GridTileBar(
                    leading: const Icon(Icons.school_rounded),
                    title: Text(nomeDisciplina),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: AppColors.flexSchemeDark.primary),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          )))),
            ),
          );
        });
  }
}

class ListaMinhasDisciplinas extends StatefulWidget {
  const ListaMinhasDisciplinas({Key? key, required this.data})
      : super(key: key);

  final QuerySnapshot data;

  @override
  State<ListaMinhasDisciplinas> createState() => _ListaMinhasDisciplinasState();
}

class _ListaMinhasDisciplinasState extends State<ListaMinhasDisciplinas> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.size,
        itemBuilder: (BuildContext context, int index) {
          final nomeDisciplina = widget.data.docs[index]['nome'];
          final userId = widget.data.docs[index]['userId'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 3,
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/listActivity',
                      arguments: DisciplinaArguments(nomeDisciplina, userId));
                },
                leading: const Icon(Icons.school_rounded),
                title: Text(nomeDisciplina),
              ),
            ),
          );
        });
  }
}

class ListaDisciplinasGerais extends StatefulWidget {
  const ListaDisciplinasGerais(
      {Key? key, required this.data, required this.userId})
      : super(key: key);

  final QuerySnapshot data;
  final String userId;

  @override
  State<ListaDisciplinasGerais> createState() => _ListaDisciplinasGeraisState();
}

class _ListaDisciplinasGeraisState extends State<ListaDisciplinasGerais> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.size,
        itemBuilder: (BuildContext context, int index) {
          final nomeDisciplina = widget.data.docs[index]['nome'];
          final iconeDisciplina = widget.data.docs[index]['caminho_do_icone'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 3,
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/listActivity',
                      arguments:
                          DisciplinaArguments(nomeDisciplina, widget.userId));
                },
                leading: Image.asset(iconeDisciplina),
                title: Text(nomeDisciplina),
              ),
            ),
          );
        });
  }
}


pw.Column conteudoPDF(String titulo, topicos, disciplina, data) {
  return pw.Column(children: [
    pw.Header(
        level: 0,
        title: 'Atividade escolar',
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: <pw.Widget>[
              pw.Text('Atividade escolar', textScaleFactor: 2),
              pw.PdfLogo()
            ])),
    pw.Header(level: 1, text: 'Título da atividade'),
    pw.Paragraph(text: titulo),
    pw.Header(level: 1, text: 'Data de entrega da atividade'),
    pw.Paragraph(text: data),
    pw.Header(level: 1, text: 'Disciplina da atividade'),
    pw.Paragraph(text: disciplina),
    pw.Header(level: 1, text: 'Tópicos da atividade'),
    pw.Paragraph(text: topicos),
  ]);
}

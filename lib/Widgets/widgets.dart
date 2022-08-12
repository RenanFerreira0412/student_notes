import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';
import 'package:student_notes/Theme/colors.dart';

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
                  border: Border.all(width: 2.0, color: AppColors.flexSchemeDark.primary),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ))
              )),
            ),
          );
        });
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({Key? key, required this.data, required this.userId})
      : super(key: key);

  final QuerySnapshot data;
  final String userId;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.data.size,
        itemBuilder: (BuildContext context, int index) {
          final nomeDisciplina = widget.data.docs[index]['nome'];

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
                leading: const Icon(Icons.school_rounded),
                title: Text(nomeDisciplina),
              ),
            ),
          );
        });
  }
}

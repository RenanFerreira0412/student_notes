import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';

class CardDisciplinas extends StatefulWidget {
  final String userId;

  const CardDisciplinas({Key? key, required this.userId}) : super(key: key);

  @override
  State<CardDisciplinas> createState() => _CardDisciplinasState();
}

class _CardDisciplinasState extends State<CardDisciplinas> {
  @override
  Widget build(BuildContext context) {
    final _disciplinaStream = FirebaseFirestore.instance
        .collection('DISCIPLINAS')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _disciplinaStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (BuildContext context, int index) {
                final nomeDisciplina = data.docs[index]['nome'];

                return Center(
                  child: Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: ListTile(
                        title: Text(nomeDisciplina),
                        hoverColor: Colors.grey[300],
                        onTap: () {
                          debugPrint(nomeDisciplina);
                          Navigator.pushNamed(context, '/listActivity',
                              arguments: DisciplinaArguments(
                                  nomeDisciplina, widget.userId));
                        },
                      )),
                );
              });
        });
  }
}

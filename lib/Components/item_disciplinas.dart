import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';

class ItemHomepage extends StatefulWidget {
  final String userId;

  const ItemHomepage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ItemHomepage> createState() => _ItemHomepageState();
}

class _ItemHomepageState extends State<ItemHomepage> {
  @override
  Widget build(BuildContext context) {
    final _disciplinaStream = FirebaseFirestore.instance
        .collection('DISCIPLINAS')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Minhas matérias'),
        const SizedBox(height: 10),
        ItemDisciplinas(
            disciplinaStream: _disciplinaStream, userId: widget.userId)
      ]),
    );
  }
}

class ItemDisciplinas extends StatelessWidget {
  final Stream<QuerySnapshot> disciplinaStream;
  final String userId;

  const ItemDisciplinas(
      {Key? key, required this.disciplinaStream, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: disciplinaStream,
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
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final nomeDisciplina = data.docs[index]['nome'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.school_rounded),
                        title: Text(nomeDisciplina),
                        hoverColor: Colors.grey[300],
                        onTap: () {
                          debugPrint(nomeDisciplina);
                          Navigator.pushNamed(context, '/listActivity',
                              arguments:
                                  DisciplinaArguments(nomeDisciplina, userId));
                        },
                      )),
                );
              });
        });
  }
}

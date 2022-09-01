import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Widgets/widgets.dart';

class ItemDisciplina extends StatefulWidget {
  final String userId;
  final bool isGridMode;

  const ItemDisciplina(
      {Key? key, required this.userId, required this.isGridMode})
      : super(key: key);

  @override
  State<ItemDisciplina> createState() => _ItemDisciplinaState();
}

class _ItemDisciplinaState extends State<ItemDisciplina> {
  @override
  Widget build(BuildContext context) {
    final _disciplinaStream = FirebaseFirestore.instance
        .collection('DISCIPLINAS')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Minhas matérias'),
        const SizedBox(height: 10),
        Expanded(
          child: ItemDisciplinas(
              disciplinaStream: _disciplinaStream,
              userId: widget.userId,
              isGridMode: widget.isGridMode),
        )
      ]),
    );
  }
}

class ItemDisciplinas extends StatelessWidget {
  final Stream<QuerySnapshot> disciplinaStream;
  final String userId;
  final bool isGridMode;

  const ItemDisciplinas(
      {Key? key,
      required this.disciplinaStream,
      required this.userId,
      required this.isGridMode})
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
          if (isGridMode) {
            return GridBuilder(data: data, userId: userId);
          } else {
            return ListBuilder(userId: userId, data: data);
          }
        });
  }
}

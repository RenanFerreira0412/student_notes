import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Widgets/widgets.dart';

class ItemDisciplina extends StatefulWidget {
  final String userId;
  final bool isMyDisciplina;

  const ItemDisciplina(
      {Key? key, required this.userId, required this.isMyDisciplina})
      : super(key: key);

  @override
  State<ItemDisciplina> createState() => _ItemDisciplinaState();
}

class _ItemDisciplinaState extends State<ItemDisciplina> {
  late String title;

  @override
  void initState() {
    super.initState();
    streamData();
  }

  streamData() {
    if (!widget.isMyDisciplina) {
      final disciplinasGerais = FirebaseFirestore.instance
          .collection('DISCIPLINAS_GERAIS')
          .snapshots();
      return ItemDisciplinas(
          disciplinaStream: disciplinasGerais,
          isMyDisciplina: widget.isMyDisciplina,
          userId: widget.userId);
    } else {
      final minhasDisciplina = FirebaseFirestore.instance
          .collection('DISCIPLINAS')
          .where('userId', isEqualTo: widget.userId)
          .snapshots();
      return ItemDisciplinas(
          disciplinaStream: minhasDisciplina,
          isMyDisciplina: widget.isMyDisciplina,
          userId: widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    title = widget.isMyDisciplina ? 'Minhas matérias' : 'Matérias gerais';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(title),
        const SizedBox(height: 10),
        Expanded(
          child: streamData(),
        )
      ]),
    );
  }
}

class ItemDisciplinas extends StatelessWidget {
  final Stream<QuerySnapshot> disciplinaStream;

  final bool isMyDisciplina;
  final String userId;

  const ItemDisciplinas(
      {Key? key,
      required this.disciplinaStream,
      required this.isMyDisciplina,
      required this.userId})
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
          if (!isMyDisciplina) {
            return ListaDisciplinasGerais(data: data, userId: userId);
          } else {
            return ListaMinhasDisciplinas(data: data);
          }
        });
  }
}


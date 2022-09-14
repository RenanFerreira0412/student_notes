import 'package:flutter/material.dart';
import 'package:student_notes/Components/item_disciplinas.dart';

class ListDisciplinas extends StatefulWidget {
  const ListDisciplinas({Key? key, this.userId}) : super(key: key);

  final String? userId;

  @override
  State<ListDisciplinas> createState() => _ListDisciplinasState();
}

class _ListDisciplinasState extends State<ListDisciplinas> {
  bool _isMyDisciplina = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matérias escolares'),
        actions: [
          if (_isMyDisciplina)
            IconButton(
              icon: const Icon(Icons.change_circle_rounded),
              onPressed: () {
                setState(() {
                  _isMyDisciplina = false;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.change_circle_rounded),
              onPressed: () {
                setState(() {
                  _isMyDisciplina = true;
                });
              },
            ),
        ],
      ),
      body: ItemDisciplina(
          userId: widget.userId!, isMyDisciplina: _isMyDisciplina),
    );
  }
}

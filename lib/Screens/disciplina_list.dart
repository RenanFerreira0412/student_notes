import 'package:flutter/material.dart';
import 'package:student_notes/Components/item_disciplinas.dart';

class ListDisciplinas extends StatefulWidget {
  const ListDisciplinas({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<ListDisciplinas> createState() => _ListDisciplinasState();
}

class _ListDisciplinasState extends State<ListDisciplinas> {
  bool _isGridMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Atividades'),
        actions: [
          if (_isGridMode)
            IconButton(
              icon: const Icon(Icons.grid_on),
              onPressed: () {
                setState(() {
                  _isGridMode = false;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                setState(() {
                  _isGridMode = true;
                });
              },
            ),
        ],
      ),
      body: ItemDisciplina(userId: widget.userId, isGridMode: _isGridMode),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';

class DataTableActivity extends StatelessWidget {
  final Stream<QuerySnapshot> _activityStream =
      FirebaseFirestore.instance.collection('ATIVIDADES').snapshots();

  final CollectionReference activityRef =
      FirebaseFirestore.instance.collection('ATIVIDADES');

  DataTableActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _activityStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        return PaginatedDataTable(
          header: const Text('Minhas Atividades'),
          rowsPerPage: 4,
          columns: const [
            DataColumn(label: Text('Título')),
            DataColumn(label: Text('Disciplina')),
            DataColumn(label: Text('Data de entrega')),
            DataColumn(label: Text('Ações')),
          ],
          source: TableSource(data, activityRef, context),
        );
      },
    );
  }
}

class TableSource extends DataTableSource {
  TableSource(this.data, this.activityRef, this.context);

  final QuerySnapshot data;
  final CollectionReference activityRef;
  final BuildContext context;

  final int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    final docId = data.docs[index].id;

    return DataRow(cells: [
      DataCell(Text(data.docs[index]['titulo'])),
      DataCell(Text(data.docs[index]['disciplina'])),
      DataCell(Text(data.docs[index]['data_entrega'])),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              editActivity(index, docId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _alertMessage(context, docId);
            },
          )
        ],
      )),
    ]);
  }

  @override
  int get rowCount => data.size;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  Future<void> _alertMessage(BuildContext context, String docId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar Atividade'),
          content: const Text('Deseja deletar essa atividade?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Prosseguir'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteActivity(docId); // Chama a função que deleta a atividade

                //SnackBar
                const SnackBar snackBar = SnackBar(
                    content: Text("Sua atividade foi deletada com sucesso! "));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> deleteActivity(String docId) {
    return activityRef
        .doc(docId)
        .delete()
        .then((value) => debugPrint("Atividade deletada"))
        .catchError((error) =>
            debugPrint("Ocorreu um erro na exclusão dessa atividade: $error"));
  }

  void editActivity(int index, String docId) {
    final titulo = data.docs[index]['titulo'];
    final disciplina = data.docs[index]['disciplina'];
    final dataEntrega = data.docs[index]['data_entrega'];
    final topicos = data.docs[index]['topicos'];

    Navigator.pushNamed(context, '/form',
        arguments: ActivityArguments(
            titulo: titulo,
            topicos: topicos,
            disciplina: disciplina,
            data: dataEntrega,
            docId: docId));
  }
}

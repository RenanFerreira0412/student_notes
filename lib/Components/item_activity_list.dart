import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';

class ItemListActivity extends StatelessWidget {
  final String nomeDisciplina;
  final String userId;

  final CollectionReference activityRef =
      FirebaseFirestore.instance.collection('ATIVIDADES');

  ItemListActivity(
      {Key? key, required this.nomeDisciplina, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _nomeDisciplinaUserId = nomeDisciplina + '_' + userId;

    final _activityFilterStream = FirebaseFirestore.instance
        .collection('ATIVIDADES')
        .where('filtroDisciplina', isEqualTo: _nomeDisciplinaUserId)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          title: Text(nomeDisciplina),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _activityFilterStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.requireData;

              return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.size,
                  itemBuilder: (BuildContext context, int index) {
                    final titulo = data.docs[index]['titulo'];
                    final disciplina = data.docs[index]['disciplina'];
                    final dataEntrega = data.docs[index]['data_entrega'];
                    final topicos = data.docs[index]['topicos'];
                    final docId = data.docs[index].id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.bookmark_rounded),
                              title: Text(titulo),
                              subtitle: Text(disciplina),
                              trailing: IconButton(
                                icon: const Icon(Icons.picture_as_pdf_rounded),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/pdfPreview',
                                      arguments: ActivityArguments(
                                          titulo: titulo,
                                          topicos: topicos,
                                          disciplina: disciplina,
                                          data: dataEntrega));
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 18, left: 18),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(dataEntrega),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          editActivity(
                                              titulo,
                                              disciplina,
                                              dataEntrega,
                                              topicos,
                                              docId,
                                              context);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _alertMessage(context, docId);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }));
  }

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

  void editActivity(String titulo, disciplina, dataEntrega, topicos,
      String docId, BuildContext context) {
    Navigator.pushNamed(context, '/form',
        arguments: ActivityArguments(
            titulo: titulo,
            topicos: topicos,
            disciplina: disciplina,
            data: dataEntrega,
            docId: docId));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> criarAtividade(
    CollectionReference activityRef,
    TextEditingController _controladorTitulo,
    _controladorData,
    _disciplinaSelecionada,
    _controladorTopicos,
    String userId) async {
  String _nomeDisciplinaUserId;

  _nomeDisciplinaUserId = _disciplinaSelecionada + '_' + userId;

  debugPrint(_nomeDisciplinaUserId);

  //Adicionando um novo documento a nossa coleção -> Atividades
  DocumentReference _novaAtividade = await activityRef.add({
    'titulo': _controladorTitulo.text,
    'data_entrega': _controladorData.text,
    'disciplina': _disciplinaSelecionada,
    'filtroDisciplina': _nomeDisciplinaUserId,
    'topicos': _controladorTopicos.text,
    'userId': userId
  }).catchError((error) =>
      debugPrint("Ocorreu um erro ao registrar sua atividade: $error"));

  debugPrint("ID da atividade: " + _novaAtividade.id);
}

Future<void> editarAtividade(
    CollectionReference activityRef,
    String documentID,
    TextEditingController _controladorTitulo,
    _controladorData,
    _disciplinaSelecionada,
    _controladorTopicos) async {
  //Atualizando um documento na nossa coleção -> Atividades
  activityRef
      .doc(documentID)
      .update({
        'titulo': _controladorTitulo.text,
        'data_entrega': _controladorData.text,
        'disciplina': _disciplinaSelecionada,
        'topicos': _controladorTopicos.text,
      })
      .then((value) => debugPrint("Atividade atualizada"))
      .catchError((error) => debugPrint(
          "Ocorreu um erro na atualização da sua atividade: $error"));
}

Future<void> limpaFormulario(TextEditingController _controladorTitulo,
    _controladorTopicos, _disciplinaSelecionada, _controladorData) async {
  _controladorTitulo.text = '';
  _controladorTopicos.text = '';
  _disciplinaSelecionada = '';
  _controladorData.text = '';
}

Future<void> addDisciplina(CollectionReference disciplinaRef,
    TextEditingController controladorDisciplina, String userId) async {

  await disciplinaRef
      .add({'nome': controladorDisciplina.text, 'userId': userId})
      .then((value) => debugPrint("Disciplina Adicionada"))
      .catchError(
          (error) => debugPrint("Falha ao adicionar essa disciplina: $error"));

  //Limpa o campo
  controladorDisciplina.text = '';
}

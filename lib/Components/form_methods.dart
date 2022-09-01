import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> criarAtividade(
    CollectionReference activityRef,
    TextEditingController _controladorTitulo,
    TextEditingController _controladorData,
    _disciplinaSelecionada,
    TextEditingController _controladorTopicos,
    String userId) async {
  String _nomeDisciplinaUserId;
  String _nomeDataEntregaUserId;

  _nomeDisciplinaUserId = _disciplinaSelecionada + '_' + userId;
  _nomeDataEntregaUserId = _controladorData.text + '_' + userId;

  debugPrint(_nomeDisciplinaUserId);

  //Adicionando um novo documento a nossa coleção -> Atividades
  DocumentReference _novaAtividade = await activityRef.add({
    'titulo': _controladorTitulo.text,
    'data_entrega': _controladorData.text,
    'disciplina': _disciplinaSelecionada,
    'filtroDisciplina': _nomeDisciplinaUserId,
    'filtroDataEntrega': _nomeDataEntregaUserId,
    'topicos': _controladorTopicos.text,
    'userId': userId
  }).catchError((error) =>
      debugPrint("Ocorreu um erro ao registrar sua atividade: $error"));

  debugPrint("ID da atividade: " + _novaAtividade.id);
}

Future<void> editarAtividade(
    CollectionReference activityRef,
    String documentID,
    String userId,
    TextEditingController _controladorTitulo,
    TextEditingController _controladorData,
    _disciplinaSelecionada,
    TextEditingController _controladorTopicos) async {
  String _nomeDataEntregaUserId;

  _nomeDataEntregaUserId = _controladorData.text + '_' + userId;

  //Atualizando um documento na nossa coleção -> Atividades
  activityRef
      .doc(documentID)
      .update({
        'titulo': _controladorTitulo.text,
        'data_entrega': _controladorData.text,
        'disciplina': _disciplinaSelecionada,
        'filtroDataEntrega': _nomeDataEntregaUserId,
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

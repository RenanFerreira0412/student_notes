import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersRef =
      FirebaseFirestore.instance.collection('USUARIOS');

  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  // Pega o ID do usuário
  String userId() {
    return _auth.currentUser!.uid;
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registrar(String email, String senha, String nome) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
      addUser(email,
          nome); // Chama o método que adiciona um usuário na coleção => USUARIOS
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não encontrado. Cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Tente novamente');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  addUser(String email, String nome) async {
    await usersRef
        .add({'nome': nome, 'email': email, 'id': userId()})
        .then((value) => debugPrint("Usuário adicionado"))
        .catchError((error) =>
            debugPrint("Falha ao adicionar usuário na coleção: $error"));
  }
}

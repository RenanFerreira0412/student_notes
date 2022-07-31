import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
   const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [Text('Minhas Informações')],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Services/auth_service.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Minhas Informações'),
            const SizedBox(height: 10),

            SizedBox(
              width: 300,
              height: 300,
              child: Image.network(
                auth.photoURL(),
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }
}

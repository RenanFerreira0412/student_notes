import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Components/item_activity_table.dart';
import 'package:student_notes/Models/activity.dart';
import 'package:student_notes/Services/auth_service.dart';
import 'package:student_notes/Widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Notes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DataTableActivity(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Mais Opções',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTileOptions(
                icone: Icons.assignment_rounded,
                title: 'Formulário',
                onTap: () {
                  Navigator.pushNamed(context, '/form',
                      arguments: ActivityArguments());
                },
                color: Colors.black),
            ListTileOptions(
                icone: Icons.account_circle_rounded,
                title: 'Meu perfil',
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                color: Colors.black),
            ListTileOptions(
                icone: Icons.logout_rounded,
                title: 'Sair',
                onTap: () {
                  auth.logout();
                },
                color: Colors.black),
          ],
        ),
      ),
    );
  }
}

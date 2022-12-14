import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Components/item_homepage.dart';
import 'package:student_notes/Models/activity.dart';
import 'package:student_notes/Services/auth_service.dart';
import 'package:student_notes/Widgets/expandable_FAB.dart';
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
                }),
            ListTileOptions(
                icone: Icons.list_alt_rounded,
                title: 'Disciplinas',
                onTap: () {
                  Navigator.pushNamed(context, '/listDisciplinas',
                      arguments: auth.userId());
                }),
            ListTileOptions(
                icone: Icons.account_circle_rounded,
                title: 'Meu perfil',
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                }),
            ListTileOptions(
                icone: Icons.settings,
                title: 'Configurações',
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                }),
            ListTileOptions(
                icone: Icons.logout_rounded,
                title: 'Sair',
                onTap: () {
                  auth.logout();
                }),
          ],
        ),
      ),
      body: ItemHomepage(userId: auth.userId()),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/form',
                  arguments: ActivityArguments());
            },
            icon: const Icon(Icons.assignment_rounded),
            tooltip: 'Criar Atividade',
          ),
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.account_circle_rounded),
            tooltip: 'Minha Conta',
          ),
          ActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
          ),
        ],
      ),
    );
  }
}

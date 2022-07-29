import 'package:flutter/material.dart';
import 'package:student_notes/Components/item_activity_table.dart';
import 'package:student_notes/Screens/form_activity.dart';
import 'package:student_notes/Widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Notes App'),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FormActivity()),
                  );
                },
                color: Colors.black),
          ],
        ),
      ),
    );
  }
}

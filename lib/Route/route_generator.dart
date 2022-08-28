import 'package:flutter/material.dart';
import 'package:student_notes/Screens/PdfPreviewPage.dart';
import 'package:student_notes/Screens/activity_list.dart';
import 'package:student_notes/Models/activity.dart';
import 'package:student_notes/Screens/form.dart';
import 'package:student_notes/Screens/homepage.dart';
import 'package:student_notes/Screens/profile.dart';
import 'package:student_notes/Screens/settings.dart';
import 'package:student_notes/Widgets/auth_check.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/authCheck':
        return MaterialPageRoute(builder: (_) => const AuthCheck());
      case '/homepage':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/form':
        //final args = settings.arguments as ActivityArguments;
        ActivityArguments argument = settings.arguments as ActivityArguments;
        return MaterialPageRoute(
            builder: (_) => Formulario(
                titulo: argument.titulo,
                topicos: argument.topicos,
                disciplina: argument.disciplina,
                data: argument.data,
                docId: argument.docId));
      case '/pdfPreview':
        ActivityArguments argument = settings.arguments as ActivityArguments;
        return MaterialPageRoute(
            builder: (_) => PdfPreviewPage(
                titulo: argument.titulo,
                topicos: argument.topicos,
                disciplina: argument.disciplina,
                data: argument.data));
      case '/profile':
        return MaterialPageRoute(builder: (_) => const UserProfile());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const Settings());
      case '/listActivity':
        DisciplinaArguments args = settings.arguments as DisciplinaArguments;

        return MaterialPageRoute(
            builder: (_) =>
                ListActivity(nomeDisciplina: args.nome, userId: args.userId));

      default:
        // Caso não exista nenhum nome de rota estabelecido no laço, retorna uma mensagem de erro, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

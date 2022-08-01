import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Services/auth_service.dart';
import 'package:student_notes/meu_aplicativo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyC6wYlEsq8REV-Tu_1ri9xFm1dWwsEVV98",
      projectId: "student-notes-aa994",
      messagingSenderId: "513849542876",
      appId: "1:513849542876:web:ac204a2515e6a5d15b0c19",
    ));
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
    ],
    child: const StudentNoteApp(),
  ));
}

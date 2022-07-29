import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Route/route_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyC6wYlEsq8REV-Tu_1ri9xFm1dWwsEVV98",
    projectId: "student-notes-aa994",
    messagingSenderId: "513849542876",
    appId: "1:513849542876:web:ac204a2515e6a5d15b0c19",
  ));

  runApp(const StudentNoteApp());
}

class StudentNoteApp extends StatelessWidget {
  const StudentNoteApp({Key? key}) : super(key: key);

  //final Future<FirebaseApp> _fbApp =  Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/homepage',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

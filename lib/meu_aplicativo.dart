import 'package:flutter/material.dart';
import 'package:student_notes/Route/route_generator.dart';

class StudentNoteApp extends StatelessWidget {
  const StudentNoteApp({Key? key}) : super(key: key);

  static const String _title = 'Student Notes';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/authCheck',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

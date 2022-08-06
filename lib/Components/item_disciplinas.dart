import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';
import 'package:student_notes/Theme/colors.dart';

class ItemHomepage extends StatefulWidget {
  final String userId;

  const ItemHomepage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ItemHomepage> createState() => _ItemHomepageState();
}

class _ItemHomepageState extends State<ItemHomepage> {
  @override
  Widget build(BuildContext context) {
    final _disciplinaStream = FirebaseFirestore.instance
        .collection('DISCIPLINAS')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Minhas matérias'),
        const SizedBox(height: 10),
        ItemDisciplinas(
            disciplinaStream: _disciplinaStream, userId: widget.userId)
      ]),
    );
  }
}

class ItemDisciplinas extends StatelessWidget {
  final Stream<QuerySnapshot> disciplinaStream;
  final String userId;

  const ItemDisciplinas(
      {Key? key, required this.disciplinaStream, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: disciplinaStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //final data = snapshot.requireData;
          return CarouselSlider(
            options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                height: 150),
            items: snapshot.data!.docs.map((DocumentSnapshot document) {
              return GestureDetector(
                  onTap: () {
                    debugPrint(document['nome']);
                    Navigator.pushNamed(context, '/listActivity',
                        arguments:
                            DisciplinaArguments(document['nome'], userId));
                  },
                  child: buildContainer(document['nome']));
            }).toList(),
          );
        });
  }
}

Widget buildContainer(String nome) {
  return Container(
    width: 500,
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color:  AppColors.flexSchemeDark.primary
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.school_rounded),

        Text(nome,
            style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

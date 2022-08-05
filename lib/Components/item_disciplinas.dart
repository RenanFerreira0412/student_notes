import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_notes/Models/activity.dart';

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

          final data = snapshot.requireData;

          return CarouselSlider.builder(
            itemCount: data.size,
            options: CarouselOptions(
              aspectRatio: 2.0,
              enlargeCenterPage: false,
              viewportFraction: 1,
                height: 200.0
            ),
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return Row(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint(document['nome']);
                        Navigator.pushNamed(context, '/listActivity',
                            arguments:
                                DisciplinaArguments(document['nome'], userId));
                      },
                      child: SizedBox(
                        height: 150,
                        child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            elevation: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.school_rounded),
                                Expanded(child: Text(document['nome']))

                              ],
                            )),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          );
        });
  }
}

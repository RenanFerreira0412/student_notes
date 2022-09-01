import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ItemHomepage extends StatefulWidget {
  const ItemHomepage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<ItemHomepage> createState() => _ItemHomepageState();
}

class _ItemHomepageState extends State<ItemHomepage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // late String event;
  late String _nomeDisciplinaUserId;

  @override
  void initState() {
    _nomeDisciplinaUserId =
        '${_focusedDay.day}/${_focusedDay.month}/${_focusedDay.year}' '_' +
            widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _activityStream = FirebaseFirestore.instance
        .collection('ATIVIDADES')
        .where('filtroDataEntrega', isEqualTo: _nomeDisciplinaUserId)
        .snapshots();

    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2040, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            daysOfWeekVisible: true,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              debugPrint('$selectedDay + $focusedDay');
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _nomeDisciplinaUserId =
                      '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}'
                              '_' +
                          widget.userId;
                  debugPrint(_nomeDisciplinaUserId);
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          StreamBuilder<QuerySnapshot>(
            stream: _activityStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.requireData;

              return ListView.builder(
                  itemCount: data.size,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final titulo = data.docs[index]['titulo'];
                    final disciplina = data.docs[index]['disciplina'];
                    return ListTile(
                      leading: const Icon(Icons.bookmark_rounded),
                      title: Text(titulo),
                      subtitle: Text(disciplina),
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}

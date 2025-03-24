// import 'package:fitness_health_tracker/widgets/rounded_button.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// import '../../../helpers/colors.dart';
//
// class VerticalScrollCalendar extends StatefulWidget {
//   @override
//   _VerticalScrollCalendarState createState() => _VerticalScrollCalendarState();
// }
//
// class _VerticalScrollCalendarState extends State<VerticalScrollCalendar> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: TableCalendar(
//               firstDay: DateTime.utc(1900, 1, 1),
//               lastDay: DateTime.utc(2200, 12, 31),
//               focusedDay: _focusedDay,
//               daysOfWeekStyle: DaysOfWeekStyle(
//                 dowTextFormatter: (date, locale) =>
//                     DateFormat('E').format(date),
//                 weekdayStyle: const TextStyle(
//                     fontSize: 14, color: Color(AppColors.pinkColor)),
//                 weekendStyle: const TextStyle(
//                     fontSize: 14, color: Color(AppColors.pinkColor)),
//               ),
//               calendarStyle: const CalendarStyle(
//                 defaultTextStyle: TextStyle(fontSize: 14),
//                 weekendTextStyle: TextStyle(
//                   fontSize: 14,
//                   color: Color(AppColors.pinkColor),
//                 ),
//                 outsideDaysVisible: false, // Hide extra days
//               ),
//               calendarFormat: CalendarFormat.month,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               headerStyle: const HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//               ),
//               availableGestures: AvailableGestures.all,
//             ),
//           ),
//         ),
//         bottomSheet: Container(
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 backgroundColor:
//                     const Color(AppColors.buttonBorderColorLightMode),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {},
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.edit,
//                     color: Colors.white,
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     'Edit Period',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../helpers/colors.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class VerticalScrollCalendar extends StatefulWidget {
  @override
  _VerticalScrollCalendarState createState() => _VerticalScrollCalendarState();
}

class _VerticalScrollCalendarState extends State<VerticalScrollCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  Set<DateTime> _selectedDays = {};

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadSavedPeriods();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      DateTime normalizedSelectedDay =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = normalizedSelectedDay;
        _endDate = null;
        _selectedDays = {_startDate!};
      } else {
        _endDate = normalizedSelectedDay.isBefore(_startDate!)
            ? _startDate
            : normalizedSelectedDay;
        _startDate = normalizedSelectedDay.isBefore(_startDate!)
            ? normalizedSelectedDay
            : _startDate;
        _selectedDays = _generateDateRange(_startDate!, _endDate!);
      }
    });
  }

  Set<DateTime> _generateDateRange(DateTime start, DateTime end) {
    Set<DateTime> days = {};
    for (DateTime date = start;
        date.isBefore(end.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      days.add(DateTime(date.year, date.month, date.day)); // Normalize dates
    }
    return days;
  }

  Future<void> _savePeriod() async {
    if (_startDate != null && _endDate != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('periods')
          .add({
        'startDate': Timestamp.fromDate(_startDate!),
        'endDate': Timestamp.fromDate(_endDate!),
      });

      setState(() {
        _startDate = null;
        _endDate = null;
        _selectedDays.clear();
      });

      _loadSavedPeriods();
    }
  }

  void _loadSavedPeriods() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('periods')
        .snapshots()
        .listen((snapshot) {
      Set<DateTime> savedPeriods = {};
      for (var doc in snapshot.docs) {
        DateTime start = (doc['startDate'] as Timestamp).toDate();
        DateTime end = (doc['endDate'] as Timestamp).toDate();

        start = DateTime(start.year, start.month, start.day);
        end = DateTime(end.year, end.month, end.day);

        savedPeriods.addAll(_generateDateRange(start, end));
      }

      setState(() {
        _selectedDays = savedPeriods;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TableCalendar(
            firstDay: DateTime.utc(1900, 1, 1),
            lastDay: DateTime.utc(2200, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              DateTime normalizedDay = DateTime(day.year, day.month, day.day);
              return _selectedDays.any((d) =>
                  d.year == normalizedDay.year &&
                  d.month == normalizedDay.month &&
                  d.day == normalizedDay.day);
            },
            onDaySelected: _onDaySelected,
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) => DateFormat('E').format(date),
              weekdayStyle: const TextStyle(fontSize: 14, color: Colors.pink),
              weekendStyle: const TextStyle(fontSize: 14, color: Colors.pink),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
              weekendTextStyle:
                  const TextStyle(fontSize: 14, color: Colors.pink),
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: Colors.pink.shade200,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade200,
                shape: BoxShape.circle,
              ),
              rangeHighlightColor: Colors.pink.shade100,
              rangeStartDecoration: BoxDecoration(
                color: Colors.pink.shade400,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: Colors.pink.shade400,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.pink.shade300,
                shape: BoxShape.circle,
              ),
            ),
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
          ),
        ),
      ),
      bottomSheet: _startDate != null && _endDate != null
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _savePeriod,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Save Period', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

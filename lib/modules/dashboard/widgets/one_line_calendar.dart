import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class OneLineCalendar extends StatefulWidget {
  @override
  _OneLineCalendarState createState() => _OneLineCalendarState();
}

class _OneLineCalendarState extends State<OneLineCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String get userId => FirebaseAuth.instance.currentUser!.uid;
  DateTime? _startDate;
  DateTime? _endDate;
  Set<DateTime> _selectedDays = {};

  Set<DateTime> _generateDateRange(DateTime start, DateTime end) {
    Set<DateTime> days = {};
    for (DateTime date = start;
        date.isBefore(end.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      days.add(DateTime(date.year, date.month, date.day)); // Normalize dates
    }
    return days;
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
  void initState() {
    super.initState();
    _loadSavedPeriods();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
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
          calendarFormat: CalendarFormat.week, // Show only week view
          headerVisible: false, // Hide header
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) => DateFormat('E').format(date),
            weekdayStyle: const TextStyle(
                fontSize: 14, color: Color(AppColors.pinkColor)),
            weekendStyle: const TextStyle(
                fontSize: 14, color: Color(AppColors.pinkColor)),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            weekendTextStyle: const TextStyle(
              fontSize: 14,
              color: Color(AppColors.pinkColor),
            ),
            outsideDaysVisible: false, // Hide extra days
            rangeHighlightColor:
                Colors.pink.shade100, // Background color for selected range
            rangeStartDecoration: BoxDecoration(
              color: Colors.pink.shade400, // Pink color for start date
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: Colors.pink.shade400, // Pink color for end date
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.pink.shade300, // Color for individual selected day
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue.shade200, // Color for today's date
              shape: BoxShape.circle,
            ),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
        )
      ],
    );
  }
}

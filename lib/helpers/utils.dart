import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class Utils {
  static String getTimeMonth() {
    DateTime today = DateTime.now();
    String formatDate = DateFormat('MMMM d').format(today);
    return formatDate;
  }

  static TimeOfDay timeToDate({required timeString}) {
    List<String> parts = timeString.split(":");
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    DateTime now = DateTime.now();
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static String convertToAmPm(String bedTimeString) {
    try {
      final date = DateFormat("HH:mm").parse(bedTimeString);
      return DateFormat("h:mm a").format(date);
    } catch (e) {
      return bedTimeString;
    }
  }

  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }
}

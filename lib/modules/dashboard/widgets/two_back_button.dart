import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/colors.dart';

class TwoBackButton extends StatefulWidget {
  final Function(String) onDateChanged;

  const TwoBackButton({super.key, required this.onDateChanged});

  @override
  _TwoBackButtonState createState() => _TwoBackButtonState();
}

class _TwoBackButtonState extends State<TwoBackButton> {
  DateTime selectedDate = DateTime.now();

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
      String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
      widget.onDateChanged(formattedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isToday = DateFormat('dd-MM-yyyy').format(selectedDate) ==
        DateFormat('dd-MM-yyyy').format(DateTime.now());

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerWidth = (screenWidth * 0.41).clamp(140, 220);
    double containerHeight = (screenHeight * 0.02).clamp(50, 70);
    double fontSize = (screenWidth * 0.04).clamp(12, 18);
    double iconSize = (screenWidth * 0.05).clamp(18, 26);

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerHeight * 0.45),
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(AppColors.appButtonColorDarkMode)
            : const Color(AppColors.skyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _changeDate(-1),
            icon: Icon(Icons.arrow_back, size: iconSize),
          ),
          Text(
            isToday ? "Today" : DateFormat('dd MMM').format(selectedDate),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          IconButton(
            onPressed: isToday ? null : () => _changeDate(1),
            icon: Icon(
              Icons.arrow_forward,
              size: iconSize,
              color: isToday ? Colors.grey : null,
            ),
          ),
        ],
      ),
    );
  }
}

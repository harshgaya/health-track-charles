import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/colors.dart';

class TwoBackButton extends StatefulWidget {
  final Function(String) onDateChanged; // Callback with formatted date

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

    return Container(
      width: 145,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(AppColors.appButtonColorDarkMode)
            : const Color(AppColors.skyColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => _changeDate(-1), // Go back one day
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 5),
          Text(
            isToday
                ? "Today"
                : DateFormat('dd MMM')
                    .format(selectedDate), // Show "Today" if it's today
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: isToday ? null : () => _changeDate(1), // Disable if today
            child: Icon(
              Icons.arrow_forward,
              color: isToday ? Colors.grey : null, // Grey if disabled
            ),
          ),
        ],
      ),
    );
  }
}

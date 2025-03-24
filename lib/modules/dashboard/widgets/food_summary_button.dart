import 'package:flutter/material.dart';

class FoodSummaryButton extends StatelessWidget {
  final VoidCallback onClick;
  final String time;
  const FoodSummaryButton(
      {super.key, required this.time, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          time,
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        InkWell(
            onTap: onClick, child: const Icon(Icons.arrow_forward_ios_sharp))
      ],
    );
  }
}

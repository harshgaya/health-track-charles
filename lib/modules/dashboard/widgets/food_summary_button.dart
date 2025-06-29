import 'package:flutter/material.dart';

import '../../../helpers/utils.dart';

class FoodSummaryButton extends StatelessWidget {
  final VoidCallback onClick;
  final String time;

  const FoodSummaryButton(
      {super.key, required this.time, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double fontSize =
            screenWidth * 0.045; // Adjust font size based on width
        double iconSize = screenWidth * 0.06; // Adjust icon size dynamically
        double padding = screenWidth * 0.02; // Dynamic padding

        return Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                  fontSize: Utils.isTablet(context)
                      ? 22
                      : fontSize, // Dynamic font size
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  decorationColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              InkWell(
                onTap: onClick,
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: Utils.isTablet(context)
                      ? 25
                      : iconSize, // Dynamic icon size
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

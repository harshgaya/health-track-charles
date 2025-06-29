import 'package:flutter/material.dart';

class CaloriCount extends StatelessWidget {
  final String image;
  final String title;
  final String total;

  const CaloriCount({
    super.key,
    required this.image,
    required this.total,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.03; // Scales based on screen width
    double iconSize = screenWidth * 0.08;
    double spacing = screenWidth * 0.02;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          image,
          height: iconSize,
        ),
        SizedBox(height: spacing),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        SizedBox(height: spacing / 2),
        Text(
          '$total/800 cal',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ],
    );
  }
}

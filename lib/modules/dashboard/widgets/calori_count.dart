import 'package:flutter/material.dart';

class CaloriCount extends StatelessWidget {
  final String image;
  final String title;
  final String total;
  const CaloriCount(
      {super.key,
      required this.image,
      required this.total,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          image,
          height: 32,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          '$total/800 cal',
          style: TextStyle(
            fontSize: 12,
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

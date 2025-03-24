import 'package:flutter/material.dart';

import '../../../helpers/colors.dart';

class GlassFill extends StatelessWidget {
  final Widget topWidget;
  final int unFillColor;
  final int fillColor;
  final int filled;
  const GlassFill(
      {super.key,
      required this.topWidget,
      required this.unFillColor,
      required this.fillColor,
      required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 260,
      decoration: BoxDecoration(
        color: Color(unFillColor),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 84,
              height: 32.25 * filled,
              decoration: BoxDecoration(
                color: Color(fillColor),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: topWidget,
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text('$filled/8 Cups'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

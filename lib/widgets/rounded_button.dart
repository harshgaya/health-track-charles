import 'package:flutter/material.dart';

import '../helpers/colors.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final int? backgroundColor;
  final int? textColor;

  const RoundedButton({
    super.key,
    required this.function,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonPadding = screenWidth * 0.04;
    final double fontSize = screenWidth * 0.045; // Adaptive font size
    final double borderRadius = screenWidth * 0.08; // Adaptive border radius

    return OutlinedButton(
      onPressed: function,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor != null
            ? Color(backgroundColor!)
            : Theme.of(context).brightness == Brightness.dark
                ? const Color(AppColors.appButtonColorDarkMode)
                : const Color(AppColors.appButtonColorLightMode),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(AppColors.buttonBorderColorDarkMode)
              : const Color(AppColors.buttonBorderColorLightMode),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: buttonPadding),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            color: textColor != null
                ? Color(textColor!)
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }
}

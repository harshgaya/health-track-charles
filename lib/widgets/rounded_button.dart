import 'package:flutter/material.dart';

import '../helpers/colors.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final int? backgroundColor;
  final int? textColor;
  const RoundedButton(
      {super.key,
      required this.function,
      required this.text,
      this.backgroundColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        function();
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor != null
            ? Color(backgroundColor!)
            : Theme.of(context).brightness == Brightness.dark
                ? const Color(AppColors.appButtonColorDarkMode)
                : const Color(AppColors.appButtonColorLightMode),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(AppColors.buttonBorderColorDarkMode)
              : const Color(AppColors.buttonBorderColorLightMode),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
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

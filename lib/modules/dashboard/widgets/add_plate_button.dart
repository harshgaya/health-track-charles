import 'package:flutter/material.dart';

import '../../../helpers/colors.dart';
import '../../../helpers/utils.dart';

class AddPlateButton extends StatelessWidget {
  final VoidCallback onClick;
  const AddPlateButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adaptive values
    double iconSize = screenWidth * 0.05; // Icon scales with screen width
    double fontSize = screenWidth * 0.04; // Text scales with width
    double spacing = screenWidth * 0.025; // Adjust spacing
    double paddingV = screenHeight * 0.01; // Vertical padding
    double paddingH = screenWidth * 0.03; // Horizontal padding

    return Theme.of(context).brightness == Brightness.dark
        ? InkWell(
            onTap: onClick,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: const Color(AppColors.appButtonColorDarkMode),
                  size: Utils.isTablet(context) ? 20 : iconSize,
                ),
                SizedBox(width: spacing),
                Text(
                  'Add Plate',
                  style: TextStyle(
                    color: const Color(AppColors.appButtonColorDarkMode),
                    fontWeight: FontWeight.w500,
                    fontSize: Utils.isTablet(context) ? 20 : fontSize,
                  ),
                )
              ],
            ),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(
                  color: Colors.transparent), // Remove default border
            ),
            onPressed: onClick,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: paddingV, horizontal: paddingH),
              decoration: Theme.of(context).brightness == Brightness.dark
                  ? const BoxDecoration()
                  : BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          offset: const Offset(0, 4), // Moves shadow downward
                          blurRadius: 6, // Softens the shadow
                          spreadRadius: 1, // Expands the shadow slightly
                        ),
                      ],
                    ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: const Color(AppColors.skyColor),
                    size: Utils.isTablet(context) ? 20 : iconSize,
                  ),
                  SizedBox(width: spacing),
                  Text(
                    'Add Plate',
                    style: TextStyle(
                      color: const Color(AppColors.skyColor),
                      fontWeight: FontWeight.w500,
                      fontSize: Utils.isTablet(context) ? 20 : fontSize,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

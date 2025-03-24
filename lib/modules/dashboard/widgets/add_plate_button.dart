import 'package:flutter/material.dart';

import '../../../helpers/colors.dart';

class AddPlateButton extends StatelessWidget {
  final VoidCallback onClick;
  const AddPlateButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? InkWell(
            onTap: onClick,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Color(AppColors.appButtonColorDarkMode),
                ),
                SizedBox(width: 10),
                Text(
                  'Add Plate',
                  style: TextStyle(
                    color: Color(AppColors.appButtonColorDarkMode),
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: const BorderSide(
                  color: Colors.transparent), // Remove default border
            ),
            onPressed: () {
              onClick();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: Theme.of(context).brightness == Brightness.dark
                  ? BoxDecoration()
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Color(AppColors.skyColor),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Add Plate',
                    style: TextStyle(
                      color: Color(AppColors.skyColor),
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

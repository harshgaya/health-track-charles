import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helpers/colors.dart';

class Vitality extends StatelessWidget {
  const Vitality({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageSize = constraints.maxWidth * 0.08; // Adaptive image size
        double fontSize = constraints.maxWidth * 0.05; // Adaptive text size

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/auth/heart.png',
              height: imageSize.clamp(20, 50), // Clamp to avoid too small/large
              width: imageSize.clamp(20, 50),
            ),
            const SizedBox(width: 8),
            Text(
              'Vitality',
              style: GoogleFonts.mulish(
                fontWeight: FontWeight.bold,
                fontSize: fontSize.clamp(16, 40), // Clamp for readability
                color: const Color(AppColors.pinkColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

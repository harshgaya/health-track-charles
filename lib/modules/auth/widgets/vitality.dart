import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../helpers/colors.dart';

class Vitality extends StatelessWidget {
  const Vitality({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/auth/heart.png',
          height: 20,
          width: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          'Vitality',
          style: GoogleFonts.mulish(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(AppColors.pinkColor),
          ),
        ),
      ],
    );
  }
}

import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFE8F4F8),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(AppColors.appButtonColorDarkMode)),
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF), foregroundColor: Color(0xFFFFFFFF)),
    textTheme: GoogleFonts.poppinsTextTheme(),
    inputDecorationTheme: const InputDecorationTheme(
      border: UnderlineInputBorder(),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Color(AppColors.buttonBorderColorLightMode), width: 2),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Color(AppColors.buttonBorderColorLightMode), width: 1),
      ),
      labelStyle: TextStyle(color: Color(AppColors.buttonBorderColorLightMode)),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.black,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
}

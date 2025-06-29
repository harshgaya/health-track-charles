import 'dart:async';
import 'package:fitness_health_tracker/modules/exercise/pages/exercise_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatingPlan extends StatefulWidget {
  const CreatingPlan({super.key});

  @override
  State<CreatingPlan> createState() => _CreatingPlanState();
}

class _CreatingPlanState extends State<CreatingPlan> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.off(() => const ExerciseCategory());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Creating your workout plan, please wait...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.06, // Adjusting text size
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Image.asset(
              'assets/auth/heart.png',
              height: screenHeight * 0.3, // Adjusting image size
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

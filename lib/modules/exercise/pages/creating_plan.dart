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
      Get.to(() => const ExerciseCategory());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Creating your workout plan please wait',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/auth/heart.png',
              height: 256,
            ),
          ],
        ),
      ),
    );
  }
}

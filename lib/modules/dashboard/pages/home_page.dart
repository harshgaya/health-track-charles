import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/food_page.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/sleep_track.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/water_track.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/calori_count.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/home_tile.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/one_line_calendar.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/vertical_calendar.dart';
import 'package:fitness_health_tracker/modules/exercise/pages/days_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../exercise/pages/exercise_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mainController = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Today',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(
                      AppColors.pinkColor,
                    ),
                  ),
                ),
                Text(
                  Utils.getTimeMonth(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => VerticalScrollCalendar());
                  },
                  child: Image.asset(
                    'assets/home/arrow_down.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    height: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                OneLineCalendar(),
                const SizedBox(
                  height: 10,
                ),
                Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                        'assets/home/heart_darkmode.png',
                        height: 140,
                      )
                    : Image.asset(
                        'assets/home/heart.png',
                        height: 140,
                      ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CaloriCount(
                      image: 'assets/home/gym.png',
                      total: '200',
                      title: 'Exersize',
                    ),
                    CaloriCount(
                      image: 'assets/home/stand.png',
                      total: '200',
                      title: 'Stand',
                    ),
                    CaloriCount(
                      image: 'assets/home/move.png',
                      total: '200',
                      title: 'Move',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const FoodPage());
                      },
                      child: const HomeTile(
                        image: 'assets/home/food.png',
                        title: 'Food',
                        subtitle: 'Track your daily food intake',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (mainController.exerciseDays.value.isNotEmpty) {
                          Get.to(() => const ExerciseCategory());
                          return;
                        }
                        Get.to(() => const DaySelect());
                      },
                      child: const HomeTile(
                        image: 'assets/home/gym_black.png',
                        title: 'Exersize',
                        subtitle: 'Energize with Our Exercises!',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const WaterTrack());
                      },
                      child: const HomeTile(
                        image: 'assets/home/water_black.png',
                        title: 'Water',
                        subtitle: 'Monitor your water consumption',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const SleepTrack());
                      },
                      child: const HomeTile(
                        image: 'assets/home/sleep_black.png',
                        title: 'Sleep',
                        subtitle: 'Log your sleep hours',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

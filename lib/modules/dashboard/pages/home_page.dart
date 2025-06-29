import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/food_page.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/sleep_track.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/water_track.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/activity_ring.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/calori_count.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/home_tile.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/vertical_calendar.dart';
import 'package:fitness_health_tracker/modules/exercise/pages/days_select.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../menstrual/menstrual_cycle_widget_base.dart';
import '../../../menstrual/ui/menstrual_calender_view.dart';
import '../../../servcies/health_services.dart';
import '../../exercise/pages/exercise_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mainController = Get.put(MainController());
  int steps = 0;
  late DailyStepCounter stepCounter;
  @override
  void initState() {
    instance.updateConfiguration(
        cycleLength: 28,
        periodDuration: 5,
        customerId: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
    mainController.getUserWeight();
    stepCounter = DailyStepCounter(
      onStepUpdate: (count, stand) {
        setState(() => steps = count);
        mainController.saveStepStandCount(steps: steps, stand: stand);
      },
    );
    stepCounter.init();
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final instance = MenstrualCycleWidget.instance!;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (mainController.userWeight.value == 0.0) {
        print('weight 0');
        return const Center(child: CircularProgressIndicator());
      }
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('steps')
              .doc(todayDate)
              .snapshots(),
          builder: (context, snapshot) {
            int totalSteps = 0;
            int totalStandMinute = 0;
            int totalExercise = 0;
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('waiting');
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData && snapshot.data!.exists) {
              print('data exists');
              final data = snapshot.data!.data() as Map<String, dynamic>;
              totalSteps = data.containsKey('steps') ? data['steps'] ?? 0 : 0;
              totalStandMinute =
                  data.containsKey('stand') ? data['stand'] ?? 0 : 0;
              totalExercise =
                  data.containsKey('exercise') ? data['exercise'] ?? 0 : 0;
            }
            dynamic stepCaloriesBurn = mainController.userWeight.value *
                0.453592 *
                totalSteps *
                0.00057;
            dynamic standCalorieBurn =
                (mainController.userWeight.value * 0.453592) *
                    totalStandMinute *
                    1.5 /
                    200;
            dynamic exerciseCalorieBurn =
                (mainController.userWeight.value * 0.453592) *
                    totalExercise *
                    6 /
                    200;
            return SafeArea(
              child: Scaffold(
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    double imageSize = screenWidth * 0.35;
                    double iconSize = screenWidth * 0.05;
                    double padding = screenWidth * 0.05;
                    double fontSize = screenWidth * 0.06;
                    double fontSize2 = screenWidth * 0.03;
                    double lineCalendar = screenWidth * 0.2;
                    return SizedBox(
                      width: Get.width,
                      // height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(() => VerticalCalendarN());
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Today',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: const Color(
                                      AppColors.pinkColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  Utils.getTimeMonth(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: fontSize2,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => VerticalCalendarN());
                                  },
                                  child: Image.asset(
                                    'assets/home/arrow_down.png',
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    height: iconSize,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Get.to(() => VerticalCalendarN());
                            },
                            child: SizedBox(
                              height: lineCalendar,
                              //width: Utils.isTablet(context) ? 500 : Get.width,
                              child: Obx(() {
                                // if (mainController.valueChanged.value ||
                                //     !mainController.valueChanged.value) {
                                //   setState(() {});
                                // }
                                return MenstrualCycleCalenderView(
                                  themeColor: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey
                                      : Colors.black,
                                  backgroundColorCode:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Color(0xFFE8F4F8),
                                  daySelectedColor: Colors.blue,
                                  hideInfoView: true,
                                  hideBottomBar: true,
                                  hideLogPeriodButton: true,
                                  isExpanded: mainController.valueChanged.value
                                      ? true
                                      : true,
                                  onDataChanged: (value) {},
                                );
                              }),
                            ),
                          ),

                          // OneLineCalendar(),

                          ActivityRings(
                              movePercent: stepCaloriesBurn * 100 / 80000,
                              exercisePercent:
                                  exerciseCalorieBurn * 100 / 80000,
                              standPercent: standCalorieBurn * 100 / 80000),
                          SizedBox(height: padding * 0.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CaloriCount(
                                image: 'assets/home/gym.png',
                                total: exerciseCalorieBurn.toStringAsFixed(0),
                                title: 'Exercise',
                              ),
                              CaloriCount(
                                image: 'assets/home/stand.png',
                                total: standCalorieBurn.toStringAsFixed(0),
                                title: 'Stand',
                              ),
                              CaloriCount(
                                image: 'assets/home/move.png',
                                total: stepCaloriesBurn.toStringAsFixed(0),
                                title: 'Move',
                              ),
                            ],
                          ),
                          SizedBox(height: padding * 1),
                          Wrap(
                            spacing: padding,
                            runSpacing: padding * 0.5,
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
                                  if (mainController
                                      .exerciseDays.value.isNotEmpty) {
                                    Get.to(() => const ExerciseCategory());
                                    return;
                                  }
                                  Get.to(() => const DaySelect());
                                },
                                child: const HomeTile(
                                  image: 'assets/home/gym_black.png',
                                  title: 'Exercise',
                                  subtitle: 'Energize with Our Exercises!',
                                ),
                              ),
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          });
    });
  }
}

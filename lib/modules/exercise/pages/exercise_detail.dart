import 'dart:async';

import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/pages/settings.dart';
import '../../dashboard/pages/home_page.dart';

class ExerciseDetails extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  const ExerciseDetails({super.key, required this.data, required this.title});

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  int selectedWeight = 50;
  String selectedUnit = 'KG';
  final mainController = Get.put(MainController());
  dynamic secondsSpent = 0;
  Timer? _minuteTimer;

  @override
  void initState() {
    super.initState();
    _startMinuteTimer();
  }

  void _startMinuteTimer() {
    _minuteTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsSpent++;
    });
  }

  @override
  void dispose() {
    _minuteTimer?.cancel();
    mainController.saveExerciseMinute(
      minutes: (secondsSpent / 60).floor(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double screenHeight = Get.height;
    double padding = screenWidth * 0.05;

    final List<int> weightList = List.generate(50, (index) => (index + 1) * 5);

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).brightness == Brightness.dark
        //     ? Colors.white
        //     : const Color(0xFFCFCFCF),
        bottomSheet: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Color(0xFFE8F4F8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, -3), // shadow above the container
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double iconSize = screenWidth * 0.08;
                  double fontSize = screenWidth * 0.03;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => HomePage());
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/home/home.png',
                              height: iconSize,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Home',
                              style: GoogleFonts.poppins(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => SettingsPage());
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/home/profile.png',
                              height: iconSize,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Profile',
                              style: GoogleFonts.poppins(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                    onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.data.length,
                  itemBuilder: (context, index) {
                    final item = widget.data[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          right: 5, bottom: Utils.isTablet(context) ? 100 : 50),
                      child: Container(
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFFB9B6B6)
                                    : const Color(0xFFCFCFCF),
                            borderRadius: BorderRadius.circular(
                                20)), // Adapt width based on screen size

                        // padding: EdgeInsets.all(
                        //     screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              child: Image.network(
                                item['image'],
                                height: Utils.isTablet(context)
                                    ? 350
                                    : screenHeight * 0.4, // Scale image height
                                fit: BoxFit.cover,
                                width: screenWidth * 0.9,
                              ),
                            ),
                            SizedBox(
                                height: screenHeight * 0.02), // Dynamic spacing
                            Padding(
                              padding: EdgeInsets.only(
                                  left: Utils.isTablet(context) ? 20 : 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '300 Cal',
                                    style: TextStyle(
                                        fontSize: screenWidth *
                                            0.04), // Responsive text
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    item['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          screenWidth * 0.05, // Scale text
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Sets',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? const Color(AppColors
                                                      .appButtonColorDarkMode)
                                                  : const Color(
                                                      AppColors.skyColor),
                                            ),
                                          ),
                                          Text(
                                            '3x',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.05),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          width: screenWidth *
                                              0.03), // Adjust spacing dynamically
                                      Column(
                                        children: [
                                          Text(
                                            'Reps',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? const Color(AppColors
                                                      .appButtonColorDarkMode)
                                                  : const Color(
                                                      AppColors.skyColor),
                                            ),
                                          ),
                                          Text(
                                            '12x',
                                            style: TextStyle(
                                                fontSize: screenWidth * 0.05),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.05),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 90,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(
                                            AppColors.appButtonColorDarkMode)
                                        : const Color(
                                            AppColors.appButtonColorLightMode),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: selectedWeight,
                                        icon: SizedBox(),
                                        dropdownColor: Colors.white,
                                        items: weightList
                                            .map(
                                              (int value) =>
                                                  DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(
                                                  '$value $selectedUnit',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (int? newValue) {
                                          print('new val $newValue');
                                          setState(() {
                                            selectedWeight = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   height: 40,
                                //   width: 76,
                                //   decoration: BoxDecoration(
                                //     color: Theme.of(context).brightness ==
                                //             Brightness.dark
                                //         ? const Color(
                                //             AppColors.appButtonColorDarkMode)
                                //         : const Color(
                                //             AppColors.appButtonColorLightMode),
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: Center(
                                //       child: Text(
                                //     '$selectedWeight kg',
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   )),
                                // ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(
                                            AppColors.appButtonColorDarkMode)
                                        : const Color(
                                            AppColors.appButtonColorLightMode),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedUnit,
                                      dropdownColor: Colors.white,
                                      // selectedItemBuilder:
                                      //     (BuildContext context) {
                                      //   return weightList.map((int value) {
                                      //     return const Text('');
                                      //   }).toList();
                                      // },
                                      icon: Row(
                                        children: [
                                          // Text(selectedUnit),
                                          Image.asset(
                                            'assets/home/arrow_down.png',
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                      items: ['KG', 'LB'].map(
                                        (unit) {
                                          return DropdownMenuItem<String>(
                                            value: unit,
                                            child: Text(unit),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedUnit = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

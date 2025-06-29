import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/alarm_set.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/hr_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth/pages/settings.dart';
import '../widgets/HRCurveChart.dart';
import 'home_page.dart';

class SleepTrack extends StatefulWidget {
  const SleepTrack({super.key});

  @override
  State<SleepTrack> createState() => _SleepTrackState();
}

class _SleepTrackState extends State<SleepTrack> {
  String selectedText = 'Day';
  List<String> times = ['Day', 'Week', 'Month', 'All'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Set Alarm',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const AlarmSet(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(AppColors.homeTileColor),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: times.map((e) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedText = e;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: selectedText == e
                                    ? Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Color(
                                            AppColors.appButtonColorDarkMode)
                                        : Color(AppColors.skyColor)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: selectedText == e
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Sleep quality',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: HRBarChart(
                selectedCategory: selectedText,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: HRLineChart(
                selectedCategory: selectedText,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    ));
  }
}

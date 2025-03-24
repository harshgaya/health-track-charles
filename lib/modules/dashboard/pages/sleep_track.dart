import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/alarm_set.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/hr_bar_chart.dart';
import 'package:flutter/material.dart';

class SleepTrack extends StatefulWidget {
  const SleepTrack({super.key});

  @override
  State<SleepTrack> createState() => _SleepTrackState();
}

class _SleepTrackState extends State<SleepTrack> {
  String selectedText = 'Days';
  List<String> times = ['Days', 'Weeks', 'Months', 'All'];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Alarm',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const AlarmSet(),
            const SizedBox(
              height: 20,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Container(
            //         height: 38,
            //         decoration: BoxDecoration(
            //           color: const Color(AppColors.homeTileColor),
            //           borderRadius: BorderRadius.circular(22),
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: times.map((e) {
            //             return InkWell(
            //               onTap: () {
            //                 setState(() {
            //                   selectedText = e;
            //                 });
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(horizontal: 3),
            //                 child: Container(
            //                   height: 32,
            //                   decoration: BoxDecoration(
            //                     color: selectedText == e
            //                         ? const Color(AppColors.skyColor)
            //                         : Colors.transparent,
            //                     borderRadius: BorderRadius.circular(22),
            //                   ),
            //                   child: Center(
            //                     child: Padding(
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 18),
            //                       child: Text(
            //                         e,
            //                         style: TextStyle(
            //                             fontSize: 13,
            //                             color: selectedText == e
            //                                 ? Colors.white
            //                                 : Colors.black),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
            HRBarChart(),
          ],
        ),
      ),
    ));
  }
}

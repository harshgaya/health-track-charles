// import 'package:fitness_health_tracker/helpers/colors.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// class HRBarChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY: 12,
//           minY: 2,
//           barTouchData: BarTouchData(enabled: true),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 reservedSize: 40,
//                 getTitlesWidget: (value, meta) {
//                   return Text('${value.toInt()}h');
//                 },
//               ),
//             ),
//             rightTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             topTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (double value, TitleMeta meta) {
//                   List<String> days = [
//                     "Mon",
//                     "Tue",
//                     "Wed",
//                     "Thu",
//                     "Fri",
//                     "Sat",
//                     "Sun"
//                   ];
//                   if (value.toInt() >= 0 && value.toInt() < days.length) {
//                     return Text(days[value.toInt()]);
//                   }
//                   return const Text("");
//                 },
//               ),
//             ),
//           ),
//           borderData: FlBorderData(show: false),
//           barGroups: [
//             BarChartGroupData(x: 0, barRods: [
//               BarChartRodData(
//                   toY: 8, color: const Color(AppColors.yellowColorBar))
//             ]),
//             BarChartGroupData(x: 1, barRods: [
//               BarChartRodData(
//                   toY: 9, color: const Color(AppColors.yellowColorBar))
//             ]),
//             BarChartGroupData(x: 2, barRods: [
//               BarChartRodData(
//                   toY: 10, color: const Color(AppColors.yellowColorBar))
//             ]),
//             BarChartGroupData(x: 3, barRods: [
//               BarChartRodData(
//                   toY: 7, color: const Color(AppColors.yellowColorBar))
//             ]),
//             BarChartGroupData(x: 4, barRods: [
//               BarChartRodData(
//                   toY: 12, color: const Color(AppColors.yellowColorBar))
//             ]),
//             BarChartGroupData(x: 5, barRods: [
//               BarChartRodData(
//                   toY: 6, color: const Color(AppColors.yellowColorBar))
//             ]),
//             BarChartGroupData(x: 6, barRods: [
//               BarChartRodData(
//                   toY: 5, color: const Color(AppColors.yellowColorBar))
//             ]),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HRBarChart extends StatefulWidget {
  @override
  _HRBarChartState createState() => _HRBarChartState();
}

class _HRBarChartState extends State<HRBarChart> {
  String selectedCategory = "Day"; // Default to 'Day'

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ["Day", "Week", "Month"].map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  }
                },
              ),
            );
          }).toList(),
        ),

        // Graph Section
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('sleep')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            List<BarChartGroupData> barGroups =
                processSleepData(docs, selectedCategory);
            print('data sleep length ${docs.length}');

            return SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 12,
                  minY: 2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}h');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          List<String> labels =
                              getBottomLabels(selectedCategory);
                          return Text(labels[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<BarChartGroupData> processSleepData(
      List<QueryDocumentSnapshot> docs, String category) {
    Map<String, double> sleepData = {};

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('sleep-duration') &&
          data.containsKey('created_at')) {
        double duration = (data['sleep-duration'] as num).toDouble();
        Timestamp timestamp = data['created_at'];

        DateTime date = timestamp.toDate();
        String key = getKeyForCategory(date, category);

        sleepData[key] = (sleepData[key] ?? 0) + duration;
      }
    }

    List<String> labels = getBottomLabels(category);
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < labels.length; i++) {
      double sleepHours = sleepData[labels[i]] ?? 0;
      barGroups.add(
        BarChartGroupData(x: i, barRods: [
          BarChartRodData(
              toY: sleepHours, color: const Color(AppColors.yellowColorBar))
        ]),
      );
    }

    return barGroups;
  }

  String getKeyForCategory(DateTime date, String category) {
    if (category == "Day") {
      return DateFormat('EEE').format(date); // Mon, Tue, etc.
    } else if (category == "Week") {
      int weekNum = (date.day / 7).ceil();
      return "Week $weekNum";
    } else {
      return DateFormat('MMM').format(date); // Jan, Feb, etc.
    }
  }

  List<String> getBottomLabels(String category) {
    if (category == "Day") {
      return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    } else if (category == "Week") {
      return ["Week 1", "Week 2", "Week 3", "Week 4"];
    } else {
      return [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
    }
  }
}

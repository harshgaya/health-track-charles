import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HRLineChart extends StatelessWidget {
  final String selectedCategory;

  const HRLineChart({Key? key, required this.selectedCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
        Map<String, double> sleepData =
            processSleepData(docs, selectedCategory);
        List<String> labels = getBottomLabels(selectedCategory);

        return SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(enabled: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text('${value.toInt()}h',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Color(0xFFEEEEEE)
                                    : Color(0xFF212121))),
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
                      if (value.toInt() >= 0 && value.toInt() < labels.length) {
                        return Text(
                          labels[value.toInt()],
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Color(0xFFEEEEEE)
                                    : Color(0xFF212121),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  isCurved: false,
                  color: Colors.amber,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                      show: true, color: Colors.amber.withOpacity(0.3)),
                  spots: List.generate(labels.length, (index) {
                    final label = labels[index];
                    return FlSpot(index.toDouble(), sleepData[label] ?? 0);
                  }),
                ),
              ],
              gridData: FlGridData(show: false),
              minY: 0,
            ),
          ),
        );
      },
    );
  }

  Map<String, double> processSleepData(
      List<QueryDocumentSnapshot> docs, String category) {
    Map<String, double> sleepData = {};

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;

      double? duration = _toDouble(data['sleep-duration']);
      Timestamp? timestamp = data['created_at'];

      if (duration != null && timestamp != null) {
        DateTime date = timestamp.toDate();
        String key = getKeyForCategory(date, category);
        sleepData[key] = (sleepData[key] ?? 0) + duration;
      }
    }

    return sleepData;
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  String getKeyForCategory(DateTime date, String category) {
    if (category == "Day") {
      return DateFormat('EEE').format(date); // Mon, Tue
    } else if (category == "Week") {
      int weekNum = (date.day / 7).ceil();
      return "Week $weekNum";
    } else {
      return DateFormat('MMM').format(date); // Jan, Feb
    }
  }

  static List<String> getBottomLabels(String category) {
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

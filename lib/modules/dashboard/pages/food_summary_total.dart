import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../widgets/two_back_button.dart';

class FoodSummaryTotal extends StatefulWidget {
  const FoodSummaryTotal({
    super.key,
  });

  @override
  State<FoodSummaryTotal> createState() => _FoodSummaryTotalState();
}

class _FoodSummaryTotalState extends State<FoodSummaryTotal> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  Map<String, double> dataMap = {
    "Fats": 25,
    "Carbs": 25,
    "Proteins": 25,
    "Sugars": 25,
  };

  final List<String> names = ['All', 'Breakfast', 'Lunch', 'Dinner'];
  String selectedName = 'All';
  List<dynamic> allList = [];
  List<dynamic> breakfastList = [];
  List<dynamic> lunchList = [];
  List<dynamic> dinnerList = [];

  final List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
                  ),
                  TwoBackButton(
                    onDateChanged: (String date) {
                      setState(() {
                        todayDate = date;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      height: 45,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: names.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedName = names[index];
                                    allList.clear();

                                    if (names[index] == 'All') {
                                      allList.addAll(breakfastList);
                                      allList.addAll(lunchList);
                                      allList.addAll(dinnerList);
                                    } else if (names[index] == 'Breakfast') {
                                      allList.addAll(breakfastList);
                                    } else if (names[index] == 'Lunch') {
                                      allList.addAll(lunchList);
                                    } else {
                                      allList.addAll(dinnerList);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: names[index] == selectedName
                                        ? Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Color(AppColors
                                                .appButtonColorDarkMode)
                                            : Color(AppColors
                                                .appButtonColorLightMode)
                                        : Colors.transparent,
                                    border: names[index] != selectedName
                                        ? Border.all(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black)
                                        : Border.all(color: Colors.transparent),
                                  ),
                                  child: Center(
                                    child: Text(
                                      names[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('food')
                          .doc(todayDate)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: 50, top: 50, left: 30),
                            child: Text(
                              "No data available",
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          );
                        }

                        var foodData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        breakfastList = foodData['breakfast'] ?? [];
                        lunchList = foodData['lunch'] ?? [];
                        dinnerList = foodData['dinner'] ?? [];

                        // Clear the allList and add data based on the selected category
                        switch (selectedName) {
                          case 'Breakfast':
                            allList = List.from(breakfastList);
                            break;
                          case 'Lunch':
                            allList = List.from(lunchList);
                            break;
                          case 'Dinner':
                            allList = List.from(dinnerList);
                            break;
                          default:
                            allList = []
                              ..addAll(breakfastList)
                              ..addAll(lunchList)
                              ..addAll(dinnerList);
                        }

                        if (allList.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Text("No food added!"),
                          );
                        }
                        var totalCalorie = allList.fold<double>(
                          0.0,
                          (sum, item) =>
                              sum +
                              num.parse(item['calorie'].toString()).toDouble(),
                        );
                        final dataMap = {
                          "Fats": allList.fold<double>(
                            0.0,
                            (sum, item) =>
                                sum +
                                (double.tryParse(
                                        item['fats']?.toString() ?? '0') ??
                                    0.0),
                          ),
                          "Carbs": allList.fold<double>(
                            0.0,
                            (sum, item) =>
                                sum +
                                (double.tryParse(
                                        item['carbs']?.toString() ?? '0') ??
                                    0.0),
                          ),
                          "Proteins": allList.fold<double>(
                            0.0,
                            (sum, item) =>
                                sum +
                                (double.tryParse(
                                        item['proteins']?.toString() ?? '0') ??
                                    0.0),
                          ),
                          "Sugars": allList.fold<double>(
                            0.0,
                            (sum, item) =>
                                sum +
                                (double.tryParse(
                                        item['sugars']?.toString() ?? '0') ??
                                    0.0),
                          ),
                        };

                        return SizedBox(
                          width: Get.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 30, top: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Total Food',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              PieChart(
                                dataMap: dataMap,
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 30,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 1.6,
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 32,
                                centerWidget: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Calories',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Color(0xFF848A9C),
                                      ),
                                    ),
                                    Text(
                                      '${totalCalorie.toStringAsFixed(1)}/2000',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : const Color(AppColors
                                                .buttonBorderColorLightMode),
                                      ),
                                    ),
                                  ],
                                ),
                                legendOptions: LegendOptions(
                                  showLegendsInRow:
                                      true, // Ensures legends are displayed in a row
                                  legendPosition: LegendPosition
                                      .bottom, // Moves legends to the bottom
                                  showLegends: true,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2), // Food Item column
                                    1: FlexColumnWidth(1), // Quantity column
                                    2: FlexColumnWidth(1), // Calories column
                                  },
                                  children: [
                                    // Header Row
                                    TableRow(
                                      //decoration: BoxDecoration(color: Colors.blue.shade200),
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Food Item",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                )),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Quantity",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Calories",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Data Rows
                                    ...allList.map((food) => TableRow(
                                          children: [
                                            _buildTableCell(food["item"]),
                                            _buildTableCell(
                                                food["quantity"].toString()),
                                            _buildTableCell(
                                                food["calorie"].toString()),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 8, right: 8),
                              //   child: Table(
                              //     // border: TableBorder.all(color: Colors.black),
                              //     columnWidths: const {
                              //       0: FlexColumnWidth(2), // Food Item column
                              //       1: FlexColumnWidth(1), // Quantity column
                              //       2: FlexColumnWidth(1), // Calories column
                              //     },
                              //     children: [
                              //       // Table Header
                              //       TableRow(
                              //         //decoration: BoxDecoration(color: Colors.blue.shade200),
                              //         children: [
                              //           TableCell(
                              //             child: Padding(
                              //               padding: EdgeInsets.all(8.0),
                              //               child: Text("Food Item",
                              //                   style: TextStyle(
                              //                     fontWeight: FontWeight.bold,
                              //                     color: Theme.of(context).brightness ==
                              //                             Brightness.dark
                              //                         ? Colors.white
                              //                         : Colors.black,
                              //                   )),
                              //             ),
                              //           ),
                              //           TableCell(
                              //             child: Padding(
                              //               padding: EdgeInsets.all(8.0),
                              //               child: Text("Quantity",
                              //                   style: TextStyle(
                              //                     fontWeight: FontWeight.bold,
                              //                     color: Theme.of(context).brightness ==
                              //                             Brightness.dark
                              //                         ? Colors.white
                              //                         : Colors.black,
                              //                   )),
                              //             ),
                              //           ),
                              //           TableCell(
                              //             child: Padding(
                              //               padding: EdgeInsets.all(8.0),
                              //               child: Text("Calories",
                              //                   style: TextStyle(
                              //                     fontWeight: FontWeight.bold,
                              //                     color: Theme.of(context).brightness ==
                              //                             Brightness.dark
                              //                         ? Colors.white
                              //                         : Colors.black,
                              //                   )),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       // Table Rows (Food Data)
                              //       for (var food in foodData)
                              //         TableRow(
                              //           children: [
                              //             TableCell(
                              //               child: Padding(
                              //                 padding: EdgeInsets.all(8.0),
                              //                 child: Text(
                              //                   food["item"],
                              //                   style: TextStyle(
                              //                     color: Theme.of(context).brightness ==
                              //                             Brightness.dark
                              //                         ? Colors.white
                              //                         : Colors.black,
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             TableCell(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(8.0),
                              //                 child: Text(
                              //                   food["quantity"],
                              //                   style: TextStyle(
                              //                     color: Theme.of(context).brightness ==
                              //                             Brightness.dark
                              //                         ? Colors.white
                              //                         : Colors.black,
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             TableCell(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(8.0),
                              //                 child: Text(
                              //                   food["calories"],
                              //                   style: TextStyle(
                              //                     color: Theme.of(context).brightness ==
                              //                             Brightness.dark
                              //                         ? Colors.white
                              //                         : Colors.black,
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../widgets/two_back_button.dart';

class FoodSummarySingle extends StatefulWidget {
  final String mealType;
  const FoodSummarySingle({super.key, required this.mealType});

  @override
  State<FoodSummarySingle> createState() => _FoodSummarySingleState();
}

class _FoodSummarySingleState extends State<FoodSummarySingle> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final Map<String, double> dataMap = {
    "Fats": 25,
    "Carbs": 25,
    "Proteins": 25,
    "Sugars": 25,
  };
  final List<Map<String, dynamic>> foodData2 = [
    {"item": "Apple", "quantity": "1", "calories": "95 kcal"},
    {"item": "Banana", "quantity": "1", "calories": "105 kcal"},
    {"item": "Chicken Breast", "quantity": "100g", "calories": "165 kcal"},
    {"item": "Rice", "quantity": "150g", "calories": "200 kcal"},
    {"item": "Milk", "quantity": "250ml", "calories": "150 kcal"},
  ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TwoBackButton(
                onDateChanged: (String date) {
                  setState(() {
                    todayDate = date;
                  });
                },
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
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 50, top: 50, left: 30),
                        child: Text("No data available"),
                      );
                    }

                    var foodData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List<dynamic> foodList = foodData[widget.mealType] ?? [];

                    if (foodList.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: Text("No food added!"),
                      );
                    }
                    var totalCalorie = foodList.fold(
                        0,
                        (sum, item) =>
                            sum + (int.parse(item['calorie']) as int));
                    return SizedBox(
                      width: Get.width,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.mealType)),
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
                            chartType: ChartType.ring, // Makes it a ring chart
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
                                  '$totalCalorie/2000',
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
                            padding: const EdgeInsets.only(left: 8, right: 8),
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
                                        child: Text("Quantity",
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
                                ...foodList.map((food) => TableRow(
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

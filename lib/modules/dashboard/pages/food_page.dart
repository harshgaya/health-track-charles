import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:fitness_health_tracker/modules/auth/pages/settings.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/food_summary_single.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/home_page.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/add_plate_button.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/food_plate_image.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/food_summary_button.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/two_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/image_upload_image.dart';
import 'food_summary_total.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double padding = screenWidth * 0.05; // 5% of screen width
            double buttonHeight = screenWidth * 0.12; // Button size scales
            double fontSize = screenWidth * 0.04;
            double buttonWidth = screenWidth * 0.9;
            double iconSize = screenWidth * 0.08;
            double fontSize2 = screenWidth * 0.03; // Dynamic font scaling

            return SizedBox(
              width: Get.width,
              height: Get.height,
              child: Padding(
                padding: EdgeInsets.only(left: padding, right: padding, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          onTap: () => Get.back(),
                          child: Icon(Icons.arrow_back)),
                    ),
                    TwoBackButton(
                      onDateChanged: (String date) {
                        setState(() {
                          todayDate = date;
                        });
                      },
                    ),

                    // Breakfast
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FoodSummaryButton(
                            time: 'Breakfast',
                            onClick: () {
                              Get.to(() =>
                                  FoodSummarySingle(mealType: 'breakfast'));
                            },
                          ),
                          Expanded(
                              child:
                                  _buildFoodStream('breakfast', screenWidth)),
                          AddPlateButton(
                            onClick: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ImageUploadWidget(timeName: 'breakfast'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Lunch
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FoodSummaryButton(
                            time: 'Lunch',
                            onClick: () {
                              Get.to(
                                  () => FoodSummarySingle(mealType: 'lunch'));
                            },
                          ),
                          Expanded(
                              child: _buildFoodStream('lunch', screenWidth)),
                          AddPlateButton(
                            onClick: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ImageUploadWidget(timeName: 'lunch'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Dinner
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FoodSummaryButton(
                            time: 'Dinner',
                            onClick: () {
                              Get.to(
                                  () => FoodSummarySingle(mealType: 'dinner'));
                            },
                          ),
                          Expanded(
                              child: _buildFoodStream('dinner', screenWidth)),
                          AddPlateButton(
                            onClick: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    ImageUploadWidget(timeName: 'dinner'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Utils.isTablet(context) ? 80 : 50),
                      child: SizedBox(
                        width: buttonWidth,
                        height: Utils.isTablet(context) ? 70 : buttonHeight,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(
                                AppColors.buttonBorderColorLightMode),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => FoodSummaryTotal());
                          },
                          child: Text(
                            'Show total summary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.isTablet(context) ? 20 : fontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
      ),
    );
  }

  // StreamBuilder to show food images dynamically
  Widget _buildFoodStream(String mealType, double screenWidth) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('food')
          .doc(todayDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Padding(
            padding: EdgeInsets.only(bottom: screenWidth * 0.1),
            child: Text("No data available",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                )),
          );
        }

        var foodData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> foodList = foodData[mealType] ?? [];

        if (foodList.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(bottom: screenWidth * 0.1),
            child: Text(
              "No food added yet",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          );
        }

        return SizedBox(
          height: screenWidth * 0.22,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foodList.length,
            itemBuilder: (context, index) {
              final item = foodList[index];
              return Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02),
                child: FoodPlateImage(
                  image: item['imageUrl'],
                  name: item['item'],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

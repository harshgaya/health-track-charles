import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/water_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../auth/pages/settings.dart';
import '../widgets/two_back_button.dart';
import 'home_page.dart';

class WaterTrack extends StatefulWidget {
  const WaterTrack({super.key});

  @override
  State<WaterTrack> createState() => _WaterTrackState();
}

class _WaterTrackState extends State<WaterTrack> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  bool waterSelected = true;
  String itemSelected = 'water';
  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            children: [
              //SizedBox(height: screenHeight * 0.02),
              // TwoBackButton(
              //   onDateChanged: (String date) {
              //     setState(() {
              //       todayDate = date;
              //     });
              //   },
              // ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                    onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
              ),

              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('water')
                      .doc(todayDate)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Water(
                        waterFilled: 0,
                        teaFilled: 0,
                        data: {},
                        itemSelected: (String val) {
                          itemSelected = val;
                        },
                        onWaterSelected: (bool value) {
                          waterSelected = value;
                        },
                      );
                    }
                    var foodData =
                        snapshot.data?.data() as Map<String, dynamic>;
                    print('map $foodData');
                    return Water(
                      waterFilled: foodData['water'] ?? 0,
                      teaFilled: foodData['tea'] ?? 0,
                      onWaterSelected: (bool value) {
                        waterSelected = value;
                      },
                      data: foodData,
                      itemSelected: (String val) {
                        itemSelected = val;
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  width: double.infinity,
                  //color: Colors.white,
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: SizedBox(
                    height: screenHeight * 0.06,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Color(AppColors.appButtonColorDarkMode)
                                : const Color(AppColors.skyColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        mainController.addWaterTea(
                            water: waterSelected,
                            value: 1,
                            context: context,
                            time: todayDate,
                            item: itemSelected);
                      },
                      child: Text(
                        'Add More Cups',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

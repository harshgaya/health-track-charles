import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/auth/pages/user_state.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/rounded_button.dart';
import '../widgets/vitality.dart';

class HeightRuler extends StatefulWidget {
  const HeightRuler({Key? key}) : super(key: key);

  @override
  _HeightRulerState createState() => _HeightRulerState();
}

class _HeightRulerState extends State<HeightRuler> {
  final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: 59);

  final mainController = Get.put(MainController());

  double selectedHeight = 5.9;

  String formatHeight(double height) {
    int feet = height.floor();
    int inches = ((height - feet) * 10).round();
    return "$feet'$inches";
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      double fontSize = screenWidth * 0.06;
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              const Align(
                  alignment: Alignment.centerLeft, child: const Vitality()),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'How tall are you?',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // The height picker
                          SizedBox(
                            height: screenHeight * 0.4, // Adaptive height
                            child: ListWheelScrollView.useDelegate(
                              controller: _controller,
                              itemExtent:
                                  screenHeight * 0.09, // Adaptive item extent
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  selectedHeight = index / 10.0;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  double heightValue = index / 10.0;
                                  double scale = 1.0 -
                                      (0.05 *
                                              (heightValue - selectedHeight)
                                                  .abs())
                                          .clamp(0, 0.5);
                                  return Center(
                                    child: Text(
                                      formatHeight(heightValue),
                                      style: GoogleFonts.mulish(
                                        fontSize: fontSize *
                                            scale, // Adaptive font size
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(1 -
                                                (0.1 *
                                                        (heightValue -
                                                                selectedHeight)
                                                            .abs())
                                                    .clamp(0, 1))
                                            : Colors.black.withOpacity(1 -
                                                (0.1 *
                                                        (heightValue -
                                                                selectedHeight)
                                                            .abs())
                                                    .clamp(0, 1)),
                                      ),
                                    ),
                                  );
                                },
                                childCount:
                                    100, // Allows scrolling from 5.0 to 9.9
                              ),
                            ),
                          ),

                          // Horizontal indicator lines
                          Positioned(
                            top: screenHeight * 0.165, // Adaptive positioning
                            left: screenWidth * 0.2,
                            right: screenWidth * 0.2,
                            child: Container(
                              width: screenWidth * 0.01, // Adaptive size
                              height: screenWidth * 0.01,
                              decoration: BoxDecoration(
                                color: const Color(AppColors.pinkColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: screenHeight * 0.16, // Adaptive positioning
                            left: screenWidth * 0.2,
                            right: screenWidth * 0.2,
                            child: Container(
                              width: screenWidth * 0.01, // Adaptive size
                              height: screenWidth * 0.01,
                              decoration: BoxDecoration(
                                color: const Color(AppColors.pinkColor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Obx(() => mainController.authLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: RoundedButton(
                                      function: () async {
                                        print(
                                            'sele ${selectedHeight.toString()}');
                                        await mainController.updateUserData(
                                            field: 'height',
                                            value: selectedHeight.toString());
                                      },
                                      textColor: 0xFFFFFFFF,
                                      text: 'Next',
                                    ),
                                  ),
                                ],
                              )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

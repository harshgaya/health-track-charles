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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Vitality(),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'How tall are you?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // The height picker
                        SizedBox(
                          height: 300,
                          child: ListWheelScrollView.useDelegate(
                            controller: _controller,
                            itemExtent: 70,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedHeight = index / 10.0;
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                double heightValue = index /
                                    10.0; // ✅ Unique height for each item
                                double scale = 1.0 -
                                    (0.05 *
                                            (heightValue - selectedHeight)
                                                .abs())
                                        .clamp(0, 0.5);
                                return Center(
                                  child: Text(
                                    formatHeight(
                                        heightValue), // ✅ Display as 5'9 instead of 5.9
                                    style: GoogleFonts.mulish(
                                      fontSize: 60 * scale,
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
                          top: 120,
                          left: 80,
                          right: 80,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(AppColors.pinkColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 103,
                          left: 80,
                          right: 80,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(AppColors.pinkColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: Get.width - 40,
                      child: Obx(() => mainController.authLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: RoundedButton(
                                    function: () async {
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
  }
}

import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/auth/pages/user_state.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../../widgets/rounded_button.dart';
import '../widgets/vitality.dart';

class DobTracker extends StatefulWidget {
  const DobTracker({Key? key}) : super(key: key);

  @override
  _HeightRulerState createState() => _HeightRulerState();
}

class _HeightRulerState extends State<DobTracker> {
  DateTime _selectedDate = DateTime.now();
  final mainController = Get.put(MainController());

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
                      'what is your birth date',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
                      child: ScrollDatePicker(
                        selectedDate: _selectedDate,
                        locale: const Locale('en'),
                        onDateTimeChanged: (DateTime value) {
                          setState(() {
                            _selectedDate = value;
                          });
                        },
                      ),
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
                                    function: () {
                                      mainController.updateUserData(
                                          field: 'dob',
                                          value: _selectedDate.toString());
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

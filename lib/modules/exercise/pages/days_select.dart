import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/modules/exercise/pages/creating_plan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/rounded_button.dart';

class DaySelect extends StatefulWidget {
  const DaySelect({Key? key}) : super(key: key);

  @override
  _DaySelectState createState() => _DaySelectState();
}

class _DaySelectState extends State<DaySelect> {
  final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: 2); // Default: 3 Days

  int selectedDays = 3; // Default selection
  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select the days you will excercise',
                      textAlign: TextAlign.center,
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
                      height: 400,
                      child: ListWheelScrollView.useDelegate(
                        controller: _controller,
                        itemExtent: 70,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedDays = index + 1;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            int dayValue = index + 1;
                            return Center(
                              child: Text(
                                "$dayValue",
                                style: GoogleFonts.mulish(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                  color: dayValue == selectedDays
                                      ? Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            );
                          },
                          childCount: 7, // 1 to 7 days
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: Get.width - 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: RoundedButton(
                              function: () async {
                                await mainController.updateUserData(
                                    field: 'exercise_days',
                                    value: selectedDays.toString());
                                mainController.exerciseDays.value =
                                    selectedDays.toString();
                                Get.to(() => const CreatingPlan());
                              },
                              textColor: 0xFFFFFFFF,
                              text: 'Next',
                            ),
                          ),
                        ],
                      ),
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

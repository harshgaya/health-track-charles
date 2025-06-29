// import 'package:fitness_health_tracker/controller/main_controller.dart';
// import 'package:fitness_health_tracker/helpers/colors.dart';
// import 'package:fitness_health_tracker/modules/auth/pages/user_state.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../widgets/rounded_button.dart';
// import '../widgets/vitality.dart';
//
// class GoalSelectionPage extends StatefulWidget {
//   const GoalSelectionPage({Key? key}) : super(key: key);
//
//   @override
//   _GoalSelectionPageState createState() => _GoalSelectionPageState();
// }
//
// class _GoalSelectionPageState extends State<GoalSelectionPage> {
//   final mainController = Get.put(MainController());
//   String selectedGoal = 'Lose Weight';
//
//   final List<String> goals = ['Lose Weight', 'Gain Weight', 'To Fit'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             const Vitality(),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'What is your goal?',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Theme.of(context).brightness == Brightness.dark
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           value: selectedGoal,
//                           isExpanded: true,
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedGoal = newValue!;
//                             });
//                           },
//                           items: goals.map((String goal) {
//                             return DropdownMenuItem<String>(
//                               value: goal,
//                               child: Text(
//                                 goal,
//                                 style: GoogleFonts.mulish(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                     SizedBox(
//                       width: Get.width - 40,
//                       child: Obx(() => mainController.authLoading.value
//                           ? const Center(
//                               child: CircularProgressIndicator(),
//                             )
//                           : Row(
//                               children: [
//                                 Expanded(
//                                   child: RoundedButton(
//                                     function: () async {
//                                       await mainController.updateUserData(
//                                           field: 'goal', value: selectedGoal);
//                                     },
//                                     textColor: 0xFFFFFFFF,
//                                     text: 'Next',
//                                   ),
//                                 ),
//                               ],
//                             )),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/auth/pages/user_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/rounded_button.dart';
import '../widgets/vitality.dart';

class GoalSelectionPage extends StatefulWidget {
  const GoalSelectionPage({Key? key}) : super(key: key);

  @override
  _GoalSelectionPageState createState() => _GoalSelectionPageState();
}

class _GoalSelectionPageState extends State<GoalSelectionPage> {
  final mainController = Get.put(MainController());
  String selectedGoal = 'Lose Weight';
  final List<String> goals = ['Lose Weight', 'Gain Weight', 'To Fit'];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = constraints.maxWidth * 0.05;
        double fontSize = constraints.maxWidth * 0.06;
        double dropdownFontSize = constraints.maxWidth * 0.04;
        double buttonHeight = constraints.maxHeight * 0.06;

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.05),
                const Align(alignment: Alignment.centerLeft, child: Vitality()),
                SizedBox(height: constraints.maxHeight * 0.03),
                Expanded(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'What is your goal?',
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.03),
                        Container(
                          width: constraints.maxWidth * 0.8,
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedGoal,
                              padding: const EdgeInsets.all(8),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGoal = newValue!;
                                });
                              },
                              items: goals.map((String goal) {
                                return DropdownMenuItem<String>(
                                  value: goal,
                                  child: Text(
                                    goal,
                                    style: GoogleFonts.mulish(
                                      fontSize: dropdownFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        SizedBox(
                          width: constraints.maxWidth * 0.9,
                          child: Obx(() => mainController.authLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : RoundedButton(
                                  function: () async {
                                    print('goal ${selectedGoal}');
                                    await mainController.updateUserData(
                                        field: 'goal', value: selectedGoal);
                                  },
                                  textColor: 0xFFFFFFFF,
                                  text: 'Next',
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
      },
    );
  }
}

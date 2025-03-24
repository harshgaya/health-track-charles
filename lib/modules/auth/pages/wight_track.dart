import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/auth/pages/height_track.dart';
import 'package:fitness_health_tracker/modules/auth/pages/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/rounded_button.dart';
import '../widgets/vitality.dart';

class WeightTrack extends StatefulWidget {
  const WeightTrack({super.key});

  @override
  State<WeightTrack> createState() => _WeightTrackState();
}

class _WeightTrackState extends State<WeightTrack> {
  RulerPickerController? _rulerPickerController;
  final mainController = Get.put(MainController());

  num currentValue = 160;

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 10, scale: 0.1),
    RulerRange(begin: 10, end: 100, scale: 1),
    RulerRange(begin: 100, end: 1000, scale: 10),
    RulerRange(begin: 1000, end: 10000, scale: 100),
    RulerRange(begin: 10000, end: 100000, scale: 1000)
  ];
  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Vitality(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'How much do you weigh?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currentValue.toStringAsFixed(1),
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 64),
                        ),
                        Text(
                          'lbs',
                          style: GoogleFonts.lato(
                              fontSize: 17,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : const Color(
                                      AppColors.buttonBorderColorLightMode)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RulerPicker(
                      controller: _rulerPickerController!,
                      onBuildRulerScaleText: (index, value) {
                        return value.toInt().toString();
                      },
                      ranges: ranges,
                      scaleLineStyleList: const [
                        ScaleLineStyle(
                            color: Color(0xFFC54573),
                            width: 2,
                            height: 30,
                            scale: 0),
                        ScaleLineStyle(
                            color: Color(0xFFC54573),
                            width: 2,
                            height: 25,
                            scale: 5),
                        ScaleLineStyle(
                            color: Color(0xFFC54573),
                            width: 2,
                            height: 15,
                            scale: -1)
                      ],
                      onValueChanged: (value) {
                        setState(() {
                          currentValue = value;
                        });
                      },
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      rulerMarginTop: 8,
                      marker: Container(
                          width: 2,
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color(0xFFC54573),
                              borderRadius: BorderRadius.circular(5))),
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
                                          field: 'weight',
                                          value: currentValue.toString());
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
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/glass_fill.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/water_track_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/two_back_button.dart';

class WaterTrack extends StatefulWidget {
  const WaterTrack({super.key});

  @override
  State<WaterTrack> createState() => _WaterTrackState();
}

class _WaterTrackState extends State<WaterTrack> {
  final int filledGlasses = 2;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  bool waterSelected = true;
  final mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<DocumentSnapshot>(
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
                      onWaterSelected: (bool value) {
                        waterSelected = value;
                      },
                    );
                  }
                  var foodData = snapshot.data?.data() as Map<String, dynamic>;
                  return Water(
                    waterFilled: foodData['water'] ?? 0,
                    teaFilled: foodData['tea'] ?? 0,
                    onWaterSelected: (bool value) {
                      waterSelected = value;
                    },
                  );
                },
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(AppColors.skyColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                mainController.addWaterTea(
                    water: waterSelected,
                    value: 1,
                    context: context,
                    time: todayDate);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add More Cups',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

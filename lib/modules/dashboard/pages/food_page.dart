// import 'package:fitness_health_tracker/helpers/colors.dart';
// import 'package:fitness_health_tracker/modules/dashboard/pages/food_summary_single.dart';
// import 'package:fitness_health_tracker/modules/dashboard/widgets/add_plate_button.dart';
// import 'package:fitness_health_tracker/modules/dashboard/widgets/food_plate_image.dart';
// import 'package:fitness_health_tracker/modules/dashboard/widgets/food_summary_button.dart';
// import 'package:fitness_health_tracker/modules/dashboard/widgets/two_back_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../widgets/image_upload_image.dart';
//
// class FoodPage extends StatefulWidget {
//   const FoodPage({super.key});
//
//   @override
//   State<FoodPage> createState() => _FoodPageState();
// }
//
// class _FoodPageState extends State<FoodPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: SizedBox(
//             width: Get.width,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   TwoBackButton(),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const FoodSummaryButton(
//                     time: 'Breakfast',
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   FoodPlateImage(),
//                   AddPlateButton(
//                     onClick: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => ImageUploadWidget(
//                           timeName: 'breakfast',
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const FoodSummaryButton(
//                     time: 'Lunch',
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   FoodPlateImage(),
//                   AddPlateButton(
//                     onClick: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => ImageUploadWidget(
//                           timeName: 'lunch',
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   const FoodSummaryButton(
//                     time: 'Dinner',
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   FoodPlateImage(),
//                   AddPlateButton(
//                     onClick: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => ImageUploadWidget(
//                           timeName: 'dinner',
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 100,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomSheet: Container(
//           color: Theme.of(context).brightness == Brightness.dark
//               ? Colors.transparent
//               : Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 backgroundColor:
//                     const Color(AppColors.buttonBorderColorLightMode),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 Get.to(() => FoodSummarySingle());
//               },
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Show total summary',
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/modules/dashboard/pages/food_summary_single.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/add_plate_button.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/food_plate_image.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/food_summary_button.dart';
import 'package:fitness_health_tracker/modules/dashboard/widgets/two_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widgets/image_upload_image.dart';

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
        body: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TwoBackButton(
                    onDateChanged: (String date) {
                      setState(() {
                        todayDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Breakfast
                  FoodSummaryButton(
                    time: 'Breakfast',
                    onClick: () {
                      Get.to(() => FoodSummarySingle(
                            mealType: 'breakfast',
                          ));
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildFoodStream('breakfast'),
                  AddPlateButton(
                    onClick: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ImageUploadWidget(timeName: 'breakfast'),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Lunch
                  FoodSummaryButton(
                    time: 'Lunch',
                    onClick: () {
                      Get.to(() => FoodSummarySingle(
                            mealType: 'lunch',
                          ));
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildFoodStream('lunch'),
                  AddPlateButton(
                    onClick: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ImageUploadWidget(timeName: 'lunch'),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Dinner
                  FoodSummaryButton(
                    time: 'Dinner',
                    onClick: () {
                      Get.to(() => FoodSummarySingle(
                            mealType: 'dinner',
                          ));
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildFoodStream('dinner'),
                  AddPlateButton(
                    onClick: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ImageUploadWidget(timeName: 'dinner'),
                      );
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.transparent
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    const Color(AppColors.buttonBorderColorLightMode),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Get.to(() => FoodSummarySingle(
                      mealType: 'breakfast',
                    ));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show total summary',
                    style: TextStyle(
                      color: Colors.white,
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

  // StreamBuilder to show food images dynamically
  Widget _buildFoodStream(String mealType) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('food')
          .doc(todayDate)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Text("No data available"),
          );
        }

        var foodData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> foodList = foodData[mealType] ?? [];

        if (foodList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Text("No food added yet"),
          );
        }

        return SizedBox(
          height: 150,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final item = foodList[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FoodPlateImage(
                    image: item['imageUrl'],
                    name: item['item'],
                  ),
                );
              }),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helpers/colors.dart';
import 'glass_fill.dart';

class Water extends StatefulWidget {
  final Map<String, dynamic> data;
  final int waterFilled;
  final int teaFilled;
  final Function(bool) onWaterSelected;
  final Function(String) itemSelected;
  const Water({
    super.key,
    required this.waterFilled,
    required this.teaFilled,
    required this.onWaterSelected,
    required this.data,
    required this.itemSelected,
  });

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  String selectedText = 'Water';
  bool waterSelected = true;
  final mainController = Get.put(MainController());
  final nameController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return SizedBox();
              // }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildGlass(label: 'Glass'),
                    const SizedBox(
                      width: 5,
                    ),
                    buildGlass(label: 'Tea'),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: addNewItem,
                      child: buildAddNewItem(),
                    ),
                  ],
                );
              }
              var foodData = snapshot.data?.data() as Map<String, dynamic>;
              List data = foodData['items'] ?? [];

              if (data.isEmpty) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildGlass(label: 'Water'),
                    const SizedBox(
                      width: 5,
                    ),
                    buildGlass(label: 'Tea'),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: addNewItem,
                      child: buildAddNewItem(),
                    ),
                  ],
                );
              }

              return SizedBox(
                height: 260,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length + 3,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: buildGlass(label: 'Water'),
                        );
                      }
                      if (index == 1) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: buildGlass(label: 'Tea'),
                        );
                      }
                      if (index == data.length + 2) {
                        return InkWell(
                          onTap: addNewItem,
                          child: buildAddNewItem(),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: buildGlass(label: data[index - 2]['name']),
                      );
                    }),
              );
            }),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            selectedText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            if (selectedText == 'Tea') {
              return InkWell(
                onTap: () {
                  if (index < (widget.data[selectedText.toLowerCase()] ?? 0)) {
                    mainController.removeWaterTea(
                        item: selectedText.toLowerCase(),
                        context: context,
                        time: todayDate);
                  }
                },
                child: Image.asset(
                  index < (widget.data[selectedText.toLowerCase()] ?? 0)
                      ? 'assets/home/tea_filled_big.png'
                      : 'assets/home/tea_empty_big.png',
                  fit: BoxFit.contain,
                ),
              );
            }
            return InkWell(
              onTap: () {
                if (index < (widget.data[selectedText.toLowerCase()] ?? 0)) {
                  mainController.removeWaterTea(
                      item: selectedText.toLowerCase(),
                      context: context,
                      time: todayDate);
                }
              },
              child: Image.asset(
                index < (widget.data[selectedText.toLowerCase()] ?? 0)
                    ? 'assets/home/water_filled_big.png'
                    : 'assets/home/water_empty_big.png',
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildGlass({
    required String label,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedText = label;
          waterSelected = true;
          widget.itemSelected(label);
          widget.onWaterSelected(true);
        });
      },
      child: GlassFill(
        topWidget: Column(
          children: [
            Image.asset(
              label == 'Tea'
                  ? 'assets/home/tea_filled.png'
                  : 'assets/home/glass_filled.png',
              height: 35,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        unFillColor: AppColors.glassUnFillColor,
        fillColor: label == 'Tea' ? AppColors.teaFillColor : AppColors.skyColor,
        filled: widget.data[label.toLowerCase()] ?? 0,
      ),
    );
  }

  Widget buildAddNewItem() {
    return GlassFill(
      filled: 0,
      topWidget: Column(
        children: [
          Icon(Icons.add_circle_outline),
          const Text(
            'Add new item',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      unFillColor: AppColors.glassUnFillColor,
      fillColor: AppColors.glassUnFillColor,
    );
  }

  void addNewItem() {
    String todayTimestamp = DateFormat('dd-MM-yyyy').format(DateTime.now());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Name of Item'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter item name")),
                    );
                    return;
                  }
                  mainController.addNewItem(
                      name: nameController.text.trim(),
                      context: context,
                      time: todayTimestamp);
                  Navigator.of(context).pop();
                },
                child: const Text("Add"),
              ),
            ],
          );
        });
  }
}

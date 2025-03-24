import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseDetails extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  const ExerciseDetails({super.key, required this.data});

  @override
  State<ExerciseDetails> createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final item = widget.data[index];
              return Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFFCFCFCF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        item['image'],
                        height: 500,
                        fit: BoxFit.cover,
                        width: Get.width - 50,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('300 Cal'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Sets',
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(
                                            AppColors.appButtonColorDarkMode)
                                        : const Color(AppColors.skyColor)),
                              ),
                              Text(
                                '3x',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Reps',
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(
                                            AppColors.appButtonColorDarkMode)
                                        : const Color(AppColors.skyColor)),
                              ),
                              Text(
                                '12x',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

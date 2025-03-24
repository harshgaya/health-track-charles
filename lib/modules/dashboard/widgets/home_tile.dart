import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const HomeTile(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(AppColors.homeTileColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                image,
                height: 24,
              ),
              Image.asset(
                'assets/home/arrow_black.png',
                height: 14,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(AppColors.grayColor),
            ),
          )
        ],
      ),
    );
  }
}

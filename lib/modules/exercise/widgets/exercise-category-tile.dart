import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/colors.dart';

class ExerciseCategoryTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback function;

  const ExerciseCategoryTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: function,
      child: Container(
        width: mediaQuery.size.width,

        padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.size.width * 0.04,
          vertical: mediaQuery.size.height * 0.015,
        ), // Adjust padding based on screen size
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                height: mediaQuery.size.height * 0.2, // Adaptive image height
                width: double.infinity,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.01), // Dynamic spacing
            Text(
              title,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.width * 0.045, // Adaptive title size
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: mediaQuery.size.width * 0.04,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(AppColors.grayColor),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Prevents overflow
                  ),
                ),
                IconButton(
                  onPressed: function,
                  icon: Icon(Icons.play_arrow,
                      size: mediaQuery.size.width * 0.07), // Adaptive icon size
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

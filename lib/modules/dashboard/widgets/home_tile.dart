import 'package:fitness_health_tracker/helpers/colors.dart';
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const HomeTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adaptive sizes
    double tileWidth = screenWidth * 0.42;
    double tileHeight = screenHeight * 0.19;
    double iconSize = Utils.isTablet(context) ? 20 : screenWidth * 0.06;
    double arrowSize = Utils.isTablet(context) ? 20 : screenWidth * 0.04;
    double fontSizeTitle = Utils.isTablet(context) ? 20 : screenWidth * 0.038;
    double fontSizeSubtitle =
        Utils.isTablet(context) ? 16 : screenWidth * 0.035;
    double padding = Utils.isTablet(context) ? 20 : screenWidth * 0.04;

    return Container(
      // height: tileHeight,
      width: tileWidth,
      padding: EdgeInsets.all(padding),
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
                height: iconSize,
              ),
              Image.asset(
                'assets/home/arrow_black.png',
                height: arrowSize,
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015), // Scaled spacing
          Text(
            title,
            style: TextStyle(
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Text(
          //   '$subtitle',
          //   softWrap: true,
          //   overflow: TextOverflow.visible,
          //   style: TextStyle(
          //     fontSize: fontSizeSubtitle,
          //     color: const Color(AppColors.grayColor),
          //   ),
          // ),
          SizedBox(
            height: Utils.isTablet(context) ? 20 : screenHeight * 0.05,
            child: Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSizeSubtitle,
                color: const Color(AppColors.grayColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

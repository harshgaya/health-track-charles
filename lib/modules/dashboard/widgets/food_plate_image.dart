// import 'package:flutter/material.dart';
//
// class FoodPlateImage extends StatelessWidget {
//   final String image;
//   final String name;
//   const FoodPlateImage({
//     super.key,
//     required this.image,
//     required this.name,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 91,
//       height: 130,
//       child: Column(
//         children: [
//           Container(
//             height: 91,
//             width: 91,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: NetworkImage(
//                   image,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             name,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? Colors.white
//                   : Colors.black,
//             ),
//             overflow: TextOverflow.ellipsis,
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:flutter/material.dart';

class FoodPlateImage extends StatelessWidget {
  final String image;
  final String name;

  const FoodPlateImage({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    // Get full screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate image size and font size based on screen width
    double imageSize = screenWidth * 0.15; // 35% of screen width
    double fontSize = screenWidth * 0.035; // 4% of screen width

    return Column(
      children: [
        Container(
          height: Utils.isTablet(context) ? 70 : imageSize,
          width: Utils.isTablet(context) ? 70 : imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(image),
            ),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: imageSize,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Utils.isTablet(context) ? 18 : fontSize,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

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
    return SizedBox(
      width: 91,
      height: 130,
      child: Column(
        children: [
          Container(
            height: 91,
            width: 91,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  image,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

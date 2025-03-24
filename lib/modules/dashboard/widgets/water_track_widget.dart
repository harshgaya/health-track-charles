import 'package:flutter/material.dart';

import '../../../helpers/colors.dart';
import 'glass_fill.dart';

class Water extends StatefulWidget {
  final int waterFilled;
  final int teaFilled;
  final Function(bool) onWaterSelected;
  const Water(
      {super.key,
      required this.waterFilled,
      required this.teaFilled,
      required this.onWaterSelected});

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  bool waterSelected = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  waterSelected = true;
                  widget.onWaterSelected(true);
                });
              },
              child: GlassFill(
                topWidget: Column(
                  children: [
                    Image.asset(
                      'assets/home/glass_filled.png',
                      height: 35,
                    ),
                    const Text(
                      'Water',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                unFillColor: AppColors.glassUnFillColor,
                fillColor: AppColors.skyColor,
                filled: widget.waterFilled,
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  waterSelected = false;
                  widget.onWaterSelected(false);
                });
              },
              child: GlassFill(
                filled: widget.teaFilled,
                topWidget: Column(
                  children: [
                    Image.asset(
                      'assets/home/tea_filled.png',
                      height: 35,
                    ),
                    const Text(
                      'Tea',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                unFillColor: AppColors.glassUnFillColor,
                fillColor: AppColors.teaFillColor,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            // GlassFill(
            //   topWidget: Column(
            //     children: [
            //       Icon(Icons.add_circle_outline),
            //       const Text(
            //         'Add new item',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(fontSize: 12),
            //       ),
            //     ],
            //   ),
            //   unFillColor: AppColors.glassUnFillColor,
            //   fillColor: AppColors.glassUnFillColor,
            // ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            waterSelected ? 'Water' : 'Tea',
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
            if (waterSelected) {
              return Image.asset(
                index < widget.waterFilled
                    ? 'assets/home/water_filled_big.png'
                    : 'assets/home/water_empty_big.png',
                fit: BoxFit.contain,
              );
            }
            return Image.asset(
              index < widget.teaFilled
                  ? 'assets/home/tea_filled_big.png'
                  : 'assets/home/tea_empty_big.png',
              fit: BoxFit.contain,
            );
          },
        ),
      ],
    );
  }
}

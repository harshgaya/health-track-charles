import 'package:fitness_health_tracker/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ActivityRings extends StatelessWidget {
  final double movePercent; // Outer ring
  final double exercisePercent; // Middle ring
  final double standPercent; // Inner ring

  const ActivityRings({
    Key? key,
    required this.movePercent,
    required this.exercisePercent,
    required this.standPercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Make size dynamic — adjust the multiplier as needed
    double size = Utils.isTablet(context) ? 150 : screenWidth * 0.35;

    return CustomPaint(
      size: Size(size, size),
      painter: _ActivityRingsPainter(
        movePercent,
        exercisePercent,
        standPercent,
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final double movePercent;
  final double exercisePercent;
  final double standPercent;

  _ActivityRingsPainter(
    this.movePercent,
    this.exercisePercent,
    this.standPercent,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = 12.0;

    void drawRing(double percent, double radius, Color color) {
      final rect = Rect.fromCircle(center: center, radius: radius);

      // Background circle (greyed)
      final backgroundPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color.withOpacity(0.2);

      canvas.drawArc(rect, 0, 2 * pi, false, backgroundPaint);

      // Progress arc
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = color;

      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * percent.clamp(0.0, 1.0),
        false,
        progressPaint,
      );
    }

    final outerRadius = size.width / 2 - strokeWidth / 2;
    final middleRadius = outerRadius - 1.5 * strokeWidth;
    final innerRadius = middleRadius - 1.5 * strokeWidth;

    drawRing(movePercent, middleRadius, const Color(0xFFFFD400));
    drawRing(exercisePercent, outerRadius, const Color(0xFF4FC3F7));
    drawRing(standPercent, innerRadius, const Color(0xFFC54573));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

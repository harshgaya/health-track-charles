import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class HeartTracker extends StatefulWidget {
  @override
  _HeartTrackerState createState() => _HeartTrackerState();
}

class _HeartTrackerState extends State<HeartTracker> {
  double exerciseProgress = 0.5; // 50% fill for outer heart
  double standingProgress = 0.25; // 25% fill for medium heart
  double walkingProgress = 0.25; // 25% fill for small heart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heart Tracker')),
      body: Center(
        child: CustomPaint(
          size: Size(200, 200), // Smaller heart size
          painter:
              HeartPainter(exerciseProgress, standingProgress, walkingProgress),
        ),
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  final double exerciseFill;
  final double standingFill;
  final double walkingFill;

  HeartPainter(this.exerciseFill, this.standingFill, this.walkingFill);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10; // Thickest border

    Paint mediumPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7; // Medium thickness

    Paint smallPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5; // Smallest thickness

    Paint exercisePaint = Paint()..color = Colors.blue.withOpacity(0.7);
    Paint standingPaint = Paint()..color = Colors.pink.withOpacity(0.7);
    Paint walkingPaint = Paint()..color = Colors.yellow.withOpacity(0.7);

    _drawHeart(canvas, size, 1.0, outerPaint, exercisePaint,
        exerciseFill); // Large Heart
    _drawHeart(canvas, size, 0.65, mediumPaint, standingPaint,
        standingFill); // Medium Heart
    _drawHeart(canvas, size, 0.3, smallPaint, walkingPaint,
        walkingFill); // Small Heart
  }

  void _drawHeart(Canvas canvas, Size size, double scale, Paint outlinePaint,
      Paint fillPaint, double fillPercentage) {
    Path heartPath = getHeartPath(size, scale);

    // Draw thick heart outline
    canvas.drawPath(heartPath, outlinePaint);

    // Clip the path so filling applies only to the thick border
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.clipPath(heartPath);

    // Fill only a percentage of the border
    Path filledPath = getPartialHeartPath(size, scale, fillPercentage);
    canvas.drawPath(filledPath, fillPaint);

    canvas.restore();
  }

  Path getHeartPath(Size size, double scale) {
    double width = size.width * scale;
    double height = size.height * scale;
    double x = (size.width - width) / 2;
    double y = (size.height - height) / 2;

    Path path = Path();
    path.moveTo(x + width / 2, y + height);

    // Adjusted top curves to be lower for a **better heart shape**
    path.cubicTo(
        x - width / 2, y + height / 2, x, y - height / 2, x + width / 2, y);
    path.cubicTo(x + width, y - height / 2, x + width * 3 / 2, y + height / 2,
        x + width / 2, y + height);

    return path;
  }

  Path getPartialHeartPath(Size size, double scale, double fillPercentage) {
    Path fullPath = getHeartPath(size, scale);
    PathMetrics pathMetrics = fullPath.computeMetrics();
    Path filledPath = Path();

    for (PathMetric metric in pathMetrics) {
      filledPath.addPath(
          metric.extractPath(0, metric.length * fillPercentage), Offset.zero);
    }

    return filledPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

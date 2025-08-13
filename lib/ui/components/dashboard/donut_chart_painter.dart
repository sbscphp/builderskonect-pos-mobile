import 'dart:math' as math;

import 'package:flutter/material.dart';

class DonutChartPainter extends CustomPainter {
  final List<OverviewData> products;
  final double animationValue;

  DonutChartPainter({
    required this.products,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 30.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Remove border radius

    double startAngle = -math.pi / 2; // Start from top

    for (final product in products) {
      final sweepAngle =
          2 * math.pi * (product.percentage / 100) * animationValue;

      paint.color = product.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += 2 * math.pi * (product.percentage / 100);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class OverviewData {
  final String name;
  final double amount;
  final Color color;
  final double percentage;

  OverviewData({
    required this.name,
    required this.amount,
    required this.color,
    required this.percentage,
  });
}

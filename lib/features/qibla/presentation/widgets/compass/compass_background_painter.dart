import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';

class CompassBackgroundPainter extends CustomPainter {
  CompassBackgroundPainter({
    required this.mainDirectionStyle,
    required this.otherDirectionStyle,
    required this.primaryColor,
    required this.secondaryBackgroundColor,
  });

  final TextStyle mainDirectionStyle;
  final TextStyle otherDirectionStyle;
  final Color primaryColor;
  final Color secondaryBackgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final outerPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius * 0.95, outerPaint);

    final innerPaint = Paint()
      ..color = secondaryBackgroundColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.9, innerPaint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final directions = [
      AppStrings.north,
      AppStrings.east,
      AppStrings.south,
      AppStrings.west,
    ];
    for (var i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) - math.pi / 2;
      final textRadius = radius * 0.75;

      textPainter
        ..text = TextSpan(
          text: directions[i],
          style: i == 0 ? mainDirectionStyle : otherDirectionStyle,
        )
        ..layout();

      final textOffset = Offset(
        center.dx + textRadius * math.cos(angle) - textPainter.width / 2,
        center.dy + textRadius * math.sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }

    final markerPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 36; i++) {
      final angle = (i * 10 * math.pi / 180) - math.pi / 2;
      final isMainDirection = i % 9 == 0;
      final startRadius = radius * (isMainDirection ? 0.82 : 0.87);
      final endRadius = radius * 0.92;

      final start = Offset(
        center.dx + startRadius * math.cos(angle),
        center.dy + startRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + endRadius * math.cos(angle),
        center.dy + endRadius * math.sin(angle),
      );

      canvas.drawLine(start, end, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

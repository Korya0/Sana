import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_fonts_family.dart';
import 'package:sana/core/theme/style/app_colors.dart';

/// Custom painter for drawing the compass background with cardinal directions and markers
class CompassBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw outer circle
    final outerPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius * 0.95, outerPaint);

    // Draw inner circle
    final innerPaint = Paint()
      ..color = AppColors.secondaryBackground.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.9, innerPaint);

    // Draw cardinal directions (N, E, S, W)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final directions = ['N', 'E', 'S', 'W'];
    for (var i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) - math.pi / 2;
      final textRadius = radius * 0.75;

      textPainter
        ..text = TextSpan(
          text: directions[i],
          style: TextStyle(
            color: i == 0 ? AppColors.gold : AppColors.grey,
            fontSize: 20,
            fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
            fontFamily: AppFontsFamily.cairo,
          ),
        )
        ..layout();

      final textOffset = Offset(
        center.dx + textRadius * math.cos(angle) - textPainter.width / 2,
        center.dy + textRadius * math.sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }

    // Draw degree markers
    final markerPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.6)
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

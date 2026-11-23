import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';

class CompassDialPainter extends CustomPainter {
  CompassDialPainter({
    required this.heading,
    required this.qiblaDirection,
    required this.isFacing,
    required this.activeColor,
    required this.neutralColor,
    required this.backgroundColor,
  });

  static const _half = 0.5;
  static const _halfTurn = 180.0;
  static const _degreesToRadians = math.pi / _halfTurn;
  static const _tickAngleStepDegrees = 5.0;
  static const _ticksPerMajor = 6;
  static const _ringRadiusRatio = 0.92;
  static const _pointerOuterRatio = 0.99;
  static const _pointerInnerRatio = 0.84;
  static const _kaabaLineRadiusRatio = 0.72;
  static const _ringWidthFacingFactor = 3.0;
  static const _ringWidthNormalFactor = 1.5;
  static const _tickWidthNorthFactor = 3.0;
  static const _tickWidthMajorFactor = 2.0;
  static const _lineWidthFacingFactor = 2.5;
  static const _lineWidthNormalFactor = 1.5;
  static const _hubStrokeFactor = 2.0;
  static const _lineStartFactor = 1.5;
  static const _alphaDimRing = 0.65;
  static const _alphaMajorTick = 0.85;
  static const _alphaDimLine = 0.8;

  final double heading; // phone heading in degrees
  final double qiblaDirection; // Qibla bearing in degrees
  final bool isFacing;
  final Color activeColor;
  final Color neutralColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * _half, size.height * _half);
    final radius = size.width * _half;

    // Dial color
    final dialColor = isFacing ? activeColor : neutralColor;
    final headingRad = heading * _degreesToRadians;
    final qiblaRad = qiblaDirection * _degreesToRadians;

    // Top pointer
    _drawTopPointer(canvas, center, radius, dialColor);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-headingRad);

    // Ring
    final ringPaint = Paint()
      ..color = dialColor.withValues(
        alpha: isFacing ? AppConstants.opacityFull : _alphaDimRing,
      )
      ..strokeWidth =
          AppSize.borderWidth *
          (isFacing ? _ringWidthFacingFactor : _ringWidthNormalFactor)
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset.zero, radius * _ringRadiusRatio, ringPaint);

    // Tick marks
    _drawTickMarks(canvas, radius, dialColor);

    // Kaaba line
    _drawKaabaLine(canvas, radius, qiblaRad, dialColor);

    // Center hub
    _drawCenterHub(canvas, dialColor);

    canvas.restore();
  }

  void _drawTopPointer(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final pointerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx - AppSize.w8, center.dy - radius * _pointerOuterRatio)
      ..lineTo(center.dx + AppSize.w8, center.dy - radius * _pointerOuterRatio)
      ..lineTo(center.dx, center.dy - radius * _pointerInnerRatio)
      ..close();

    canvas.drawPath(path, pointerPaint);
  }

  void _drawTickMarks(Canvas canvas, double radius, Color color) {
    final tickPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < AppConstants.qiblaCompassTicks; i++) {
      final angle = i * _tickAngleStepDegrees * _degreesToRadians;
      final isMajor = i % _ticksPerMajor == 0;
      final isNorth = i == 0;

      final len = isNorth ? AppSize.p12 : (isMajor ? AppSize.p8 : AppSize.p4);
      tickPaint
        ..strokeWidth = isNorth
            ? AppSize.borderWidth * _tickWidthNorthFactor
            : (isMajor
                  ? AppSize.borderWidth * _tickWidthMajorFactor
                  : AppSize.borderWidth)
        ..color = color.withValues(
          alpha: isNorth
              ? AppConstants.opacityFull
              : (isMajor ? _alphaMajorTick : AppConstants.opacityDisabled),
        );

      final startR = radius * _ringRadiusRatio - len;
      final endR = radius * _ringRadiusRatio;

      final start = Offset(startR * math.sin(angle), -startR * math.cos(angle));
      final end = Offset(endR * math.sin(angle), -endR * math.cos(angle));

      canvas.drawLine(start, end, tickPaint);
    }
  }

  void _drawKaabaLine(
    Canvas canvas,
    double radius,
    double qiblaRad,
    Color color,
  ) {
    final linePaint = Paint()
      ..color = color.withValues(
        alpha: isFacing ? AppConstants.opacityFull : _alphaDimLine,
      )
      ..strokeWidth =
          AppSize.borderWidth *
          (isFacing ? _lineWidthFacingFactor : _lineWidthNormalFactor)
      ..style = PaintingStyle.stroke;

    final startR = AppSize.qiblaCenterDotSize * _lineStartFactor;
    final endR = radius * _kaabaLineRadiusRatio;

    final start = Offset(
      startR * math.sin(qiblaRad),
      -startR * math.cos(qiblaRad),
    );
    final end = Offset(endR * math.sin(qiblaRad), -endR * math.cos(qiblaRad));

    canvas.drawLine(start, end, linePaint);
  }

  void _drawCenterHub(Canvas canvas, Color color) {
    final hubPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, AppSize.p12, hubPaint);

    final hubStroke = Paint()
      ..color = color
      ..strokeWidth = AppSize.borderWidth * _hubStrokeFactor
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset.zero, AppSize.p12, hubStroke);

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, AppSize.p4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CompassDialPainter oldDelegate) {
    return heading != oldDelegate.heading ||
        qiblaDirection != oldDelegate.qiblaDirection ||
        isFacing != oldDelegate.isFacing ||
        activeColor != oldDelegate.activeColor ||
        neutralColor != oldDelegate.neutralColor ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

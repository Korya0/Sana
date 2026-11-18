import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';

class TasbeehBeadArc extends StatelessWidget {
  const TasbeehBeadArc({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    super.key,
    this.isFreeMode = false,
  });

  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final bool isFreeMode;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _BeadArcPainter(
      progress: progress,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      isFreeMode: isFreeMode,
      isRtl: Directionality.of(context) == TextDirection.rtl,
    ),
  );
}

class _BeadArcPainter extends CustomPainter {
  const _BeadArcPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.isFreeMode,
    required this.isRtl,
  });

  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final bool isFreeMode;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height * AppConstants.beadArcCenterYRatio,
    );
    final radiusX = size.width * AppConstants.beadArcRadiusXRatio;
    final radiusY = size.height * AppConstants.beadArcRadiusYRatio;
    final beads = [
      for (var i = 0; i < AppConstants.tasbeehBeadCount; i++)
        _beadOffset(i, center, radiusX, radiusY),
    ];
    final activeIndex = isFreeMode
        ? beads.length
        : (progress * beads.length).round().clamp(0, beads.length);

    // Guide arc
    canvas.drawPath(
      Path()..addPolygon(beads, false),
      Paint()
        ..color = inactiveColor.withValues(alpha: AppConstants.opacityGhost)
        ..style = PaintingStyle.stroke
        ..strokeWidth = AppSize.borderWidth,
    );

    // Beads
    final beadRadius = AppSize.r4 * AppConstants.beadArcBeadRadiusRatio;
    final activePaint = Paint()..color = activeColor;
    final inactivePaint = Paint()..color = inactiveColor;
    for (var i = 0; i < beads.length; i++) {
      canvas.drawCircle(
        beads[i],
        beadRadius,
        i < activeIndex ? activePaint : inactivePaint,
      );
    }
  }

  Offset _beadOffset(int index, Offset center, double radiusX, double radiusY) {
    final t = index / (AppConstants.tasbeehBeadCount - 1);
    final angle = isRtl ? math.pi + t * math.pi : 2 * math.pi - t * math.pi;

    return Offset(
      center.dx + radiusX * math.cos(angle),
      center.dy + radiusY * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(covariant _BeadArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.isFreeMode != isFreeMode ||
      oldDelegate.isRtl != isRtl ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.inactiveColor != inactiveColor;
}

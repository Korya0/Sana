// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';
import 'package:sana/features/qibla/data/services/qibla_service.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_arrow.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_background_painter.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_kaaba_icon.dart';

/// Main compass widget that orchestrates all compass components
class QiblaCompass extends StatelessWidget {
  final double heading;
  final double qiblaDirection;
  final bool activeColor;

  const QiblaCompass({
    super.key,
    required this.heading,
    required this.qiblaDirection,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = (QiblaConstants.compassSize);

    // Calculate angle for the rotating compass background
    final compassRotation = -heading * math.pi / 180;

    // Calculate angle difference for the arrow
    final angleDiff = QiblaService.calculateAngleDifference(
      heading,
      qiblaDirection,
    );
    final arrowRotation = angleDiff * math.pi / 180;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fixed Kaaba Icon at top
        CompassKaabaIcon(activeColor: activeColor),

        SizedBox(height: (30)),

        // Compass with rotating arrow
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Rotating Compass Background
              Transform.rotate(
                angle: compassRotation,
                child: CustomPaint(
                  size: Size(size, size),
                  painter: CompassBackgroundPainter(),
                ),
              ),

              // Rotating Arrow (points to Kaaba)
              CompassArrow(
                rotation: arrowRotation,
                activeColor: activeColor,
                compassSize: size,
              ),

              // Center Dot
              _buildCenterDot(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenterDot(BuildContext context) {
    return Container(
      width: (QiblaConstants.centerDotSize),
      height: (QiblaConstants.centerDotSize),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.scaffoldBackground,
        border: Border.all(color: AppColors.gold, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

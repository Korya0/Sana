// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';

/// Rotating arrow that points towards the Qibla direction
class CompassArrow extends StatelessWidget {
  final double rotation;
  final bool activeColor;
  final double compassSize;

  const CompassArrow({
    super.key,
    required this.rotation,
    required this.activeColor,
    required this.compassSize,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.navigation_rounded,
            color: activeColor
                ? QiblaConstants.activeColor
                : QiblaConstants.inactiveColor,
            size: (QiblaConstants.navigationIconSize),
          ),
          SizedBox(height: compassSize / 2 - (20)),
        ],
      ),
    );
  }
}

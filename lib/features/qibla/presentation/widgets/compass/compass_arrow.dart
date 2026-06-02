import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/qibla/constants/qibla_ui_constants.dart';

class CompassArrow extends StatelessWidget {
  const CompassArrow({
    required this.rotation,
    required this.activeColor,
    required this.compassSize,
    super.key,
  });
  final double rotation;
  final bool activeColor;
  final double compassSize;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.navigation_rounded,
            color: activeColor ? context.color.secondary : context.color.primary,
            size: QiblaUiConstants.navigationIconSize.r(context),
          ),
          SizedBox(
            height: compassSize / 2 - QiblaUiConstants.centerDotSize.r(context),
          ),
        ],
      ),
    );
  }
}


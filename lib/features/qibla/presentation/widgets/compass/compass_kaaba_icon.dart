// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/qibla/data/qibla_constants.dart';

/// Fixed Kaaba icon displayed at the top of the compass
class CompassKaabaIcon extends StatelessWidget {
  final bool activeColor;

  const CompassKaabaIcon({super.key, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all((16)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.textPrimary),
      ),
      child: Icon(
        FlutterIslamicIcons.solidKaaba,
        color: activeColor
            ? QiblaConstants.activeColor
            : QiblaConstants.inactiveColor,
        size: (QiblaConstants.kaabaIconSize),
      ),
    );
  }
}

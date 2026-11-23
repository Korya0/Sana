import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';

class CompassKaabaIcon extends StatelessWidget {
  const CompassKaabaIcon({
    required this.isFacing,
    super.key,
  });

  static const _borderFactor = 2.0;

  final bool isFacing;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.color.iconBrand;
    final normalColor = context.color.iconNeutral;
    final color = isFacing ? activeColor : normalColor;

    return Container(
      width: AppSize.qiblaKaabaIconSize,
      height: AppSize.qiblaKaabaIconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.color.secondaryScaffoldBackgroundColor,
        border: Border.all(
          color: color,
          width: AppSize.borderWidth * _borderFactor,
        ),
      ),
      child: Center(
        child: Icon(
          AppIcons.kaaba,
          size: AppSize.icon24,
          color: color,
        ),
      ),
    );
  }
}

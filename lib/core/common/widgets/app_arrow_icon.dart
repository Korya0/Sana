import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:solar_icons/solar_icons.dart';

enum AppArrowDirection { up, down, left, right }

/// A reusable arrow icon widget that uses a single base icon ([SolarIconsBold.altArrowLeft])
/// and rotates it to the desired direction.
///
/// This approach is optimal for Shorebird patches as it doesn't require adding new icon assets.
class AppArrowIcon extends StatelessWidget {
  const AppArrowIcon({
    this.direction = AppArrowDirection.left,
    this.size = 14,
    this.color = AppColors.textPrimary,
    super.key,
  });

  final AppArrowDirection direction;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final quarterTurns = switch (direction) {
      AppArrowDirection.left => 0,
      AppArrowDirection.up => 1,
      AppArrowDirection.right => 2,
      AppArrowDirection.down => 3,
    };

    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Icon(
        SolarIconsBold.altArrowLeft,
        size: size.r(context),
        color: color,
      ),
    );
  }
}


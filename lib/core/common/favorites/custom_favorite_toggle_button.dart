import 'package:sana/core/constants/app_spacing.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomFavoriteToggleButton extends StatelessWidget {
  const CustomFavoriteToggleButton({
    required this.onPressed,
    required this.isFav,
    super.key,
    this.iconSize,
  });

  final bool isFav;
  final VoidCallback onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        unawaited(playVibrate());
        onPressed();
      },
      icon: Icon(
        isFav ? SolarIconsBold.heart : SolarIconsOutline.heart,
        color: context.color.primary,
        size: iconSize ?? AppSpacing.s20.r(context),
      ),
    );
  }
}

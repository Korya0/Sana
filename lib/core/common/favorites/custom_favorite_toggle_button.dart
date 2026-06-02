import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomFavoriteToggleButton extends StatelessWidget {
  const CustomFavoriteToggleButton({
    required this.onPressed,
    required this.isFav,
    super.key,
    this.iconSize = 20,
  });

  final bool isFav;
  final VoidCallback onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        unawaited(AppFeedback.playVibrate());
        onPressed();
      },
      icon: Icon(
        isFav ? SolarIconsBold.heart : SolarIconsOutline.heart,
        color: context.color.primary,
        size: iconSize,
      ),
    );
  }
}


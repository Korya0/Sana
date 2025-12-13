import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback? onSharePressed;
  final double? iconSize;

  const ShareButton({super.key, this.onSharePressed, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onSharePressed,
      icon: Icon(
        SolarIconsOutline.share,
        color: AppColors.grey,
        size: iconSize != null ? (iconSize!) : (20),
      ),
    );
  }
}

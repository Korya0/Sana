import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class ShareButton extends StatelessWidget {

  const ShareButton({super.key, this.onSharePressed, this.iconSize});
  final VoidCallback? onSharePressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onSharePressed,
      icon: Icon(
        SolarIconsOutline.share,
        color: AppColors.grey,
        size: iconSize ?? 20,
      ),
    );
  }
}

class CopyButton extends StatelessWidget {

  const CopyButton({super.key, this.onCopyPressed, this.iconSize});
  final VoidCallback? onCopyPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onCopyPressed,
      icon: Icon(
        SolarIconsOutline.copy,
        color: AppColors.grey,
        size: iconSize ?? 20,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class CustomSearchIconButton extends StatelessWidget {
  const CustomSearchIconButton({
    required this.onToggleSearch,
    super.key,
  });

  final VoidCallback onToggleSearch;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        SolarIconsOutline.magnifier,
        color: AppColors.gold,
      ),
      onPressed: onToggleSearch,
    );
  }
}

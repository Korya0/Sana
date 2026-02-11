import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class UpdateIcon extends StatelessWidget {
  const UpdateIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.system_update_rounded,
        color: AppColors.gold,
        size: 64,
      ),
    );
  }
}

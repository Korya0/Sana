import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

import 'package:sana/core/utils/context_extension.dart';

class UpdateIcon extends StatelessWidget {
  const UpdateIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.v24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.system_update_rounded,
        color: AppColors.iconAccent,
        size: 64.r(context),
      ),
    );
  }
}


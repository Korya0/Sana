import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';

import 'package:sana/core/utils/utils.dart';

class UpdateIcon extends StatelessWidget {
  const UpdateIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.v24),
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.system_update_rounded,
        color: context.color.primary,
        size: 64.r(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_progress.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  // Creates row
  const ZikrActionsRow({
    required this.progress,
    super.key,
    this.onResetTap,
    this.onCopyTap,
  });

  final ZikrProgress progress;
  final VoidCallback? onResetTap;
  final VoidCallback? onCopyTap;

  // Builds row
  @override
  Widget build(BuildContext context) {
    final isCompleted = progress.isCompleted;
    final remainingCount = progress.remaining;
    final canReset = progress.canReset;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Actions
        Row(
          children: [
            AppIconButton(
              icon: AppIcons.refresh,
              tooltip: AppStrings.resetCounter,
              color: canReset
                  ? context.color.iconBrand
                  : context.color.iconDisabled,
              onPressed: canReset ? onResetTap : null,
            ),
            AppGap.w(AppSize.p8),
            AppIconButton(
              icon: AppIcons.copy,
              tooltip: AppStrings.copyZikrText,
              onPressed: onCopyTap,
            ),
          ],
        ),

        // Counter
        Semantics(
          label: AppStrings.remainingCounterLabel,
          value: isCompleted ? AppStrings.completed : '$remainingCount',
          excludeSemantics: true,
          child: ZikrCounter(
            completedCount: progress.completedCount,
            totalCount: progress.totalCount,
          ),
        ),
      ],
    );
  }
}

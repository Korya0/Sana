import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  // Creates row
  const ZikrActionsRow({
    required this.completedCount,
    required this.totalCount,
    super.key,
    this.onResetPressed,
    this.onCopyPressed,
  });

  final int completedCount;
  final int totalCount;
  final VoidCallback? onResetPressed;
  final VoidCallback? onCopyPressed;

  // Builds row
  @override
  Widget build(BuildContext context) {
    final isCompleted = completedCount >= totalCount;
    final remainingCount = totalCount - completedCount;
    final canReset = completedCount > 0;

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
              onPressed: canReset ? onResetPressed : null,
            ),
            AppGap.w(AppSize.p8),
            AppIconButton(
              icon: AppIcons.copy,
              tooltip: AppStrings.copyZikrText,
              onPressed: onCopyPressed,
            ),
          ],
        ),

        // Counter
        Semantics(
          label: AppStrings.remainingCounterLabel,
          value: isCompleted ? AppStrings.completed : '$remainingCount',
          excludeSemantics: true,
          child: ZikrCounter(
            completedCount: completedCount,
            totalCount: totalCount,
          ),
        ),
      ],
    );
  }
}

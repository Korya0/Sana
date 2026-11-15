import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  // Creates row
  const ZikrActionsRow({
    required this.completedCount,
    required this.totalCount,
    super.key,
    this.onResetPressed,
  });

  final int completedCount;
  final int totalCount;
  final VoidCallback? onResetPressed;

  // Builds row
  @override
  Widget build(BuildContext context) {
    final isCompleted = completedCount >= totalCount;
    final remainingCount = totalCount - completedCount;
    final canReset = completedCount > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Reset action
        AppIconButton(
          icon: AppIcons.refresh,
          tooltip: AppStrings.resetCounter,
          color: canReset
              ? context.color.iconBrand
              : context.color.iconDisabled,
          onPressed: canReset ? onResetPressed : null,
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

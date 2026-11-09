import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  const ZikrActionsRow({
    required this.completedCount,
    required this.totalCount,
    super.key,
    this.onOptionsPressed,
  });

  final int completedCount;
  final int totalCount;
  final VoidCallback? onOptionsPressed;

  @override
  Widget build(BuildContext context) {
    final isCompleted = completedCount >= totalCount;
    final remainingCount = totalCount - completedCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onOptionsPressed != null)
          AppIconButton(
            icon: AppIcons.moreVertical,
            tooltip: AppStrings.zikrOptionsTitle,
            onPressed: onOptionsPressed,
          )
        else
          const SizedBox.shrink(),
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

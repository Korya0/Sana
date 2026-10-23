import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  const ZikrActionsRow({
    required this.completedCount,
    required this.totalCount,
    super.key,
  });

  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final isCompleted = completedCount >= totalCount;
    final remainingCount = totalCount - completedCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
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

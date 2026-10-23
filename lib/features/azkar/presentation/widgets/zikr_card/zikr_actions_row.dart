import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  const ZikrActionsRow({
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    super.key,
  });

  final int remainingCount;
  final double progress;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Semantics(
        label: AppStrings.remainingCounterLabel,
        value: isCompleted ? AppStrings.completed : '$remainingCount',
        excludeSemantics: true,
        child: ZikrCounter(
          remainingCount: remainingCount,
          progress: progress,
          isCompleted: isCompleted,
        ),
      ),
    ],
  );
}

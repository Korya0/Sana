import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';

class ZikrActionsRow extends StatelessWidget {
  const ZikrActionsRow({
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    super.key,
    this.onShare,
    this.onCopy,
  });
  final int remainingCount;
  final double progress;
  final bool isCompleted;
  final AsyncCallback? onShare;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          label: AppStrings.shareAndCopyOptions,
          button: true,
          child: SizedBox(
            width: 60.r(context),
            height: 60.r(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60.r(context),
                  height: 60.r(context),
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 4,
                    color: context.color.primary.withValues(alpha: 0.05),
                  ),
                ),
                CombinedShareCopyButton(
                  onSharePressed: onShare,
                  onCopyPressed: onCopy,
                  iconSize: 20.r(context),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.v10),
          child: Semantics(
            label: AppStrings.remainingCounterLabel,
            value: isCompleted ? AppStrings.completed : '$remainingCount',
            excludeSemantics: true,
            child: ZikrCounter(
              remainingCount: remainingCount,
              progress: progress,
              isCompleted: isCompleted,
            ),
          ),
        ),
      ],
    );
  }
}

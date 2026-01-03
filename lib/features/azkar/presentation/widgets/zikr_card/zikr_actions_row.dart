import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/share_buttons.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  final String text;
  final int remainingCount;
  final double progress;
  final bool isCompleted;
  final VoidCallback? onShare;

  const ZikrActionsRow({
    super.key,
    required this.text,
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShareButton(iconSize: 20, onSharePressed: onShare),

        Padding(
          padding: const EdgeInsets.only(right: (10)),
          child: ZikrCounter(
            remainingCount: remainingCount,
            progress: progress,
            isCompleted: isCompleted,
          ),
        ),
      ],
    );
  }
}

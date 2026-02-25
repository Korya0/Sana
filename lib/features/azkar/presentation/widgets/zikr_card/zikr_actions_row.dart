import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/combined_share_copy_button.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart';

class ZikrActionsRow extends StatelessWidget {
  const ZikrActionsRow({
    required this.text,
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
    super.key,
    this.onShare,
  });
  final String text;
  final int remainingCount;
  final double progress;
  final bool isCompleted;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CombinedShareCopyButton(
          isCombined: false,
          onSharePressed: onShare ?? () {},
          onCopyPressed: () async {
            await Clipboard.setData(ClipboardData(text: text)).then((_) {
              if (context.mounted) {
                AppToast.show(context, 'تم نسخ الذكر بنجاح');
              }
            });
          },
          iconSize: 20,
        ),

        Padding(
          padding: const EdgeInsets.only(right: 10),
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

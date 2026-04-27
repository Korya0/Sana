import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toggle_list.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

class TeachingTopicCard extends StatelessWidget {
  const TeachingTopicCard({required this.topic, super.key});
  final TeachingPrayerTopicModel topic;

  Future<void> _copyToClipboard() async {
    final textToCopy = '${topic.title}\n\n${topic.content}';
    await Clipboard.setData(ClipboardData(text: textToCopy));
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AppToggleList(
        margin: const EdgeInsets.only(bottom: AppSpacing.v8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                topic.title,
                style: AppTextStyles.font16W500White(context),
              ),
            ),
            CombinedShareCopyButton(
              onCopyPressed: _copyToClipboard,
              iconSize: 14.r(context),
            ),
          ],
        ),
        children: _buildFormattedContent(context),
      ),
    );
  }

  List<Widget> _buildFormattedContent(BuildContext context) {
    return topic.points.map((point) {
      if (point.number.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.v12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  point.text,
                  style: AppTextStyles.font14W600primary(context).copyWith(
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.v12),
          child: Text(
            point.text,
            style: AppTextStyles.font14W600primary(context).copyWith(
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        );
      }
    }).toList();
  }
}

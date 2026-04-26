import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toggle_list.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';

class TeachingTopicCard extends StatefulWidget {
  const TeachingTopicCard({required this.topic, super.key});
  final TeachingPrayerTopicModel topic;

  @override
  State<TeachingTopicCard> createState() => _TeachingTopicCardState();
}

class _TeachingTopicCardState extends State<TeachingTopicCard> {
  Future<void> _copyToClipboard() async {
    final textToCopy = '${widget.topic.title}\n\n${widget.topic.content}';
    await Clipboard.setData(ClipboardData(text: textToCopy));
  }

  @override
  Widget build(BuildContext context) {
    return AppToggleList(
      margin: const EdgeInsets.only(bottom: AppSpacing.v8),
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.topic.title,
              style: AppTextStyles.font14W600White(context),
            ),
          ),

          CombinedShareCopyButton(
            onCopyPressed: _copyToClipboard,
            iconSize: 14,
          ),
        ],
      ),

      children: [
        ..._buildFormattedContent(
          context,
          widget.topic.content,
        ),
      ],
    );
  }

  List<Widget> _buildFormattedContent(BuildContext context, String content) {
    final points = TeachingContentParser.parseContent(content);

    return points.map((point) {
      if (point.number.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.v12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  point.text,
                  style: AppTextStyles.font14W400Grey(
                    context,
                  ).copyWith(height: 1.6),
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
            style: AppTextStyles.font14W400Grey(
              context,
            ).copyWith(height: 1.6),
            textAlign: TextAlign.justify,
          ),
        );
      }
    }).toList();
  }
}

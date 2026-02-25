import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/common/widgets/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_topic_share_card.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';
import 'package:solar_icons/solar_icons.dart';

class TeachingTopicCard extends StatefulWidget {
  const TeachingTopicCard({required this.topic, super.key});
  final TeachingPrayerTopic topic;

  @override
  State<TeachingTopicCard> createState() => _TeachingTopicCardState();
}

class _TeachingTopicCardState extends State<TeachingTopicCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _shareCard() async {
    await WidgetToImage.shareWidget(
      context: context,
      widget: TeachingTopicShareCard(topic: widget.topic),
      imageName: 'share_teaching_${widget.topic.title.hashCode}',
    );
  }

  Future<void> _copyToClipboard() async {
    final textToCopy = '${widget.topic.title}\n\n${widget.topic.content}';
    await Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      if (mounted) {
        AppToast.show(context, 'تم نسخ محتوى ${widget.topic.title}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.textWhite.withValues(alpha: 0.05),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _toggleExpand,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic Header
                Row(
                  children: [
                    Icon(
                      SolarIconsOutline.documentText,
                      color: AppColors.gold.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.topic.title,
                        style: AppTextStyles.font16W600White(context),
                      ),
                    ),
                    CombinedShareCopyButton(
                      isCombined: false,
                      onSharePressed: _shareCard,
                      onCopyPressed: _copyToClipboard,
                      iconSize: 18,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.grey,
                      size: 20,
                    ),
                  ],
                ),

                // Expandable Content
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: _isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            const CustomAppDivider(),
                            const SizedBox(height: 12),
                            ..._buildFormattedContent(
                              context,
                              widget.topic.content,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormattedContent(BuildContext context, String content) {
    final points = TeachingContentParser.parseContent(content);

    return points.map((point) {
      if (point.number.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  point.number,
                  style: AppTextStyles.font14W600Gold(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  point.text,
                  style: AppTextStyles.font14W400WhiteHeight16(context),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            point.text,
            style: AppTextStyles.font14W400WhiteHeight16(context),
            textAlign: TextAlign.justify,
          ),
        );
      }
    }).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';
import 'package:solar_icons/solar_icons.dart';

class TeachingTopicCard extends StatefulWidget {
  const TeachingTopicCard({required this.topic, super.key});
  final TeachingPrayerTopicModel topic;

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

  Future<void> _copyToClipboard() async {
    final textToCopy = '${widget.topic.title}\n\n${widget.topic.content}';
    await Clipboard.setData(ClipboardData(text: textToCopy));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.v8),
      decoration: featureCardDecoration(
        color: AppColors.scaffoldBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          onTap: _toggleExpand,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.v12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic Header
                Row(
                  children: [
                    Icon(
                      SolarIconsOutline.documentText,
                      color: AppColors.iconPrimary.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.v12),
                    Expanded(
                      child: Text(
                        widget.topic.title,
                        style: AppTextStyles.font16W600White(context),
                      ),
                    ),
                    IconButton(
                      onPressed: _copyToClipboard,
                      icon: const Icon(
                        SolarIconsOutline.copy,
                        color: AppColors.iconPrimary,
                        size: 18,
                      ),
                      tooltip: AppStrings.copyContent,
                    ),
                    const SizedBox(width: AppSpacing.v8),
                    AppArrowIcon(
                      direction: _isExpanded
                          ? AppArrowDirection.up
                          : AppArrowDirection.down,
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
                            const SizedBox(height: AppSpacing.v12),
                            const CustomAppDivider(),
                            const SizedBox(height: AppSpacing.v12),
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
          padding: const EdgeInsets.only(bottom: AppSpacing.v12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.v8,
                  vertical: AppSpacing.v4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                ),
                child: Text(
                  point.number,
                  style: AppTextStyles.font14W600primary(context),
                ),
              ),
              const SizedBox(width: AppSpacing.v12),
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

// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/core/common/widgets/share_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_topic_share_card.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solar_icons/solar_icons.dart';

class TeachingTopicCard extends StatefulWidget {
  final TeachingPrayerTopic topic;

  const TeachingTopicCard({super.key, required this.topic});

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
    try {
      final imageBytes = await WidgetToImage.capture(
        context: context,
        widget: TeachingTopicShareCard(topic: widget.topic),
      );

      if (imageBytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/share_teaching_${widget.topic.title.hashCode}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(file.path)], text: widget.topic.title);
    } catch (e) {
      debugPrint('Error sharing card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpanded
              ? AppColors.gold.withOpacity(0.2)
              : AppColors.textWhite.withOpacity(0.05),
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
                      color: AppColors.gold.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.topic.title,
                        style: AppTextStyles.font16W600White(context),
                      ),
                    ),
                    ShareButton(onSharePressed: _shareCard, iconSize: 18),
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
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.1),
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
          padding: const EdgeInsets.only(bottom: 12.0),
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

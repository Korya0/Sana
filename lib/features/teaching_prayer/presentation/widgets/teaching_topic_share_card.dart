import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/app_info_and_qr_code.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';

class TeachingTopicShareCard extends StatelessWidget {
  final TeachingPrayerTopic topic;

  const TeachingTopicShareCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, // Fixed width for consistent image generation
      color: AppColors.scaffoldBackground, // Black background
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Decorative Top
          Center(
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            topic.title,
            style: AppTextStyles.font20W700White(
              context,
            ).copyWith(color: AppColors.gold, fontSize: 24),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.grey),
          const SizedBox(height: 16),

          // Content
          ..._buildFormattedContent(context, topic.content),

          const SizedBox(height: 32),

          // Footer
          const AppInfoShare(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildFormattedContent(BuildContext context, String content) {
    final points = TeachingContentParser.parseContent(content);
    // Limit content for sharing card to avoid super long images if needed,
    // but for now we render all.

    return points.map((point) {
      if (point.number.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                point.number,
                style: AppTextStyles.font16W600Gold(context),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  point.text,
                  style: AppTextStyles.font16W600White(
                    context,
                  ).copyWith(height: 1.6, color: AppColors.white),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
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
            style: AppTextStyles.font16W600White(
              context,
            ).copyWith(height: 1.6, color: AppColors.white),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),
        );
      }
    }).toList();
  }
}

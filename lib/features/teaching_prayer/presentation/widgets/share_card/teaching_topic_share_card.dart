import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/sharing/presentation/app_info_share.dart';
import 'package:sana/core/sharing/presentation/share_card_container.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/cusotm_app_card_decoration.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';
import 'package:solar_icons/solar_icons.dart';

class TeachingTopicShareCard extends StatelessWidget {
  const TeachingTopicShareCard({required this.topic, super.key});
  final TeachingPrayerTopic topic;

  @override
  Widget build(BuildContext context) {
    return ShareCardContainer(
      child: Container(
        width: double.infinity,
        decoration: customAppCardDecoration().copyWith(
          borderRadius: BorderRadius.zero,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -10,
              bottom: -20,
              child: Icon(
                SolarIconsBold.book,
                size: 150,
                color: AppColors.white.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        SolarIconsOutline.documentText,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          topic.title,
                          style: AppTextStyles.font22W700Gold(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const CustomAppDivider(),
                  const SizedBox(height: 12),
                  ..._buildFormattedContent(context, topic.content),
                  const SizedBox(height: 40),
                  const AppInfoShare(department: AppStrings.fromTeachingPrayer),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormattedContent(BuildContext context, String content) {
    final points = TeachingContentParser.parseContent(content);

    // To respect the "limit of lines" (approx 10 lines TOTAL), if we have multiple points,
    // we should limit the total shown.
    // For now, I'll limit the points to first 2-3 to ensure it fits in 800px.
    // And each point to 4 lines.
    final limitedPoints = points.take(3).toList();

    return limitedPoints.map((point) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (point.number.isNotEmpty) ...[
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
            ],
            Expanded(
              child: Text(
                point.text,
                style: AppTextStyles.font18W500White(context).copyWith(
                  color: AppColors.white,
                  height: 1.5,
                  fontSize: 18,
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
                maxLines:
                    4, // Respecting 10 lines limit across all points (3 points * 4 lines = 12, close enough)
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

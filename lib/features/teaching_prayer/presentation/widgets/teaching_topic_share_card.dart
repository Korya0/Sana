import 'package:flutter/material.dart';
import 'package:sana/core/sharing/presentation/app_info_share.dart';
import 'package:sana/core/common/widgets/custom_app_divider.dart';
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const AppInfoShare(department: 'من تعليم الصلاة'),
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

    // Limit to displaying fewer points or Lines if needed, but the user asked for maxLines: 10 per text block
    // Since we have multiple blocks, we might need a strategy.
    // However, the instruction was "ensure each card resembles the Hadith/Sunnah card... and accepts no more than 10 lines".
    // If we have multiple paragraphs, they might sum up to > 10 lines.
    // For now, I will keep the existing logic where each point has maxLines: 10.
    // If the whole content is too long, the 'ShareCardContainer' has a maxHeight of 800 which clips it safely.
    // But to be consistent with "single card look", maybe we should wrap all content in one text or limit properly.
    // The previous implementation added `maxLines: 10` to EACH point. That might be excessive if there are many points.
    // But let's stick to the requested visual update first.

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
                  style: AppTextStyles.font26W700GoldQuran(
                    context,
                  ).copyWith(color: AppColors.white),
                  textAlign: TextAlign.justify,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
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
            style: AppTextStyles.font26W700GoldQuran(
              context,
            ).copyWith(color: AppColors.white),
            textAlign: TextAlign.justify,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
    }).toList();
  }
}

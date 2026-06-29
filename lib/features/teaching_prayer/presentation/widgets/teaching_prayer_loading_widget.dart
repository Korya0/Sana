import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';
import 'package:sana/features/teaching_prayer/utils/teaching_content_parser.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TeachingPrayerLoadingWidget extends StatelessWidget {
  const TeachingPrayerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CustomScrollView(
        slivers: [
          const CommonSliverAppBar(title: AppStrings.teachPrayer),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.v16,
              vertical: AppSpacing.v16,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TeachingSectionCard(
                    section: TeachingPrayerSectionModel(
                      id: index.toString(),
                      title: 'جاري التحميل...',
                      topics: List.generate(
                        2,
                        (i) => const TeachingPrayerTopicModel(
                          id: 'loading',
                          title: 'اسم الموضوع جاري التحميل',
                          content: 'محتوى الموضوع جاري التحميل...',
                          points: [
                            TeachingPointModel(
                              number: '1-',
                              text:
                                  'هذا هو السطر الأول من محتوى الموضوع جاري التحميل لتعبئة المساحة.',
                            ),
                            TeachingPointModel(
                              number: '2-',
                              text:
                                  'هذا هو السطر الثاني من محتوى الموضوع جاري التحميل لتعبئة المساحة بشكل أفضل.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                childCount: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';
import 'package:sana/features/teaching_prayer/presentation/widgets/teaching_section_card.dart';

class TeachingPrayerLoadingWidget extends StatelessWidget {
  const TeachingPrayerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: CustomScrollView(
        slivers: [
          const CommonSliverAppBar(title: AppStrings.teachPrayer),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => TeachingSectionCard(
                  section: TeachingPrayerSectionModel(
                    id: index.toString(),
                    title: 'جاري التحميل...',
                    topics: List.generate(
                      3,
                      (i) => const TeachingPrayerTopicModel(
                        id: 'loading',
                        title: 'اسم الموضوع جاري التحميل',
                        content: 'محتوى الموضوع جاري التحميل...',
                      ),
                    ),
                  ),
                ),
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

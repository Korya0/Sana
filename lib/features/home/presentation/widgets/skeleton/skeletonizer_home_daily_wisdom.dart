import 'package:flutter/material.dart';
import 'package:sana/core/common/layout/custom_carousel_slider.dart';
import 'package:sana/core/common/widgets/card/daily_content_base_card.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerHomeDailyWisdom extends StatelessWidget {
  const SkeletonizerHomeDailyWisdom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.v12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CategorySectionHeader(title: AppStrings.dailyWisdomHeader),
        Skeletonizer(
          child: CustomCarouselSlider(
            height: 160,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlayCurve: Curves.easeInOutCubic,
            autoPlay: false,
            items: [
              DailyContentBaseCard(
                source: 'المصدر',
                content:
                    'محتوى تجريبي طويل ليظهر بنفس المساحة تماما محتوى تجريبي طويل ليظهر بنفس المساحة تماما ',
                title: AppStrings.hadithOfTheDay,
                explanation:
                    'شرح تجريبي طويل ليظهر بنفس المساحة تماما ويحاكي النص الحقيقي',
                isFavorite: false,
                onFavoriteToggle: () {},
                footerText: 'محتوى تجريبي طويل ليظهر بنفس المساحة تماما',
                onTap: () {},
                onSharePressed: () {},
                onCopyPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

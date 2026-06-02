import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/common/layout/custom_carousel_slider.dart';
import 'package:sana/features/home/presentation/widgets/category/category_section_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerHomeDailyWisdom extends StatelessWidget {
  const SkeletonizerHomeDailyWisdom({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        spacing: AppSpacing.v12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategorySectionHeader(title: AppStrings.dailyWisdomHeader),

          CustomCarouselSlider(
            height: 190,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: false,
            items: [
              Container(
                decoration: customAppCardDecoration(context),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.v20,
                  vertical: AppSpacing.v12,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Bone.text(words: 2),
                        Bone.icon(),
                      ],
                    ),
                    SizedBox(height: AppSpacing.v20),
                    Center(child: Bone.text(words: 10)),
                    Spacer(),
                    Center(child: Bone.text(words: 3)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

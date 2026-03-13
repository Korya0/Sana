import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
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
          // Header Skeleton
          const CategorySectionHeader(title: AppStrings.dailyWisdomHeader),

          // Carousel Item Skeleton
          Container(
            height: 190,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
            decoration: customAppCardDecoration(),
            padding: const EdgeInsets.all(AppSpacing.v20),
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
    );
  }
}

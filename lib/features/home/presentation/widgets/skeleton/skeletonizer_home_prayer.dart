import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerHomePrayer extends StatelessWidget {
  const SkeletonizerHomePrayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.4),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppSpacing.radiusS),
            bottomRight: Radius.circular(AppSpacing.radiusS),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Container(color: AppColors.scaffoldBackground),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: kIsWeb ? AppSpacing.v16 : 0,
                      left: AppSpacing.v16,
                      right: AppSpacing.v16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(words: 2),
                        Bone.text(words: 1),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.v4),
                  
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Bone.text(words: 2),
                        SizedBox(height: 4),
                        Bone.text(
                          words: 1,
                          style: AppTextStyles.font24W700,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.v4),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v12),
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 5,
                      mainAxisSpacing: AppSpacing.v4,
                      crossAxisSpacing: AppSpacing.v6,
                      childAspectRatio: 1.4,
                      children: List.generate(
                        5,
                        (index) => Bone(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.v6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


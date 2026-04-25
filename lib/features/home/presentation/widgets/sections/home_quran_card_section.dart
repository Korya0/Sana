import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/common/decorations/custom_app_card_decoration.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:solar_icons/solar_icons.dart';

class HomeQuranCardSection extends StatelessWidget {
  const HomeQuranCardSection({super.key});
  @override
  Widget build(BuildContext context) {
    return AppAnimations.pressScale(
      Container(
        width: double.infinity,
        decoration: customAppCardDecoration(),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              child: Icon(
                SolarIconsBold.book,
                size: 100,
                color: AppColors.iconWhite.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.v20,
                vertical: AppSpacing.v16,
              ),
              child: Row(
                spacing: AppSpacing.v8,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.v8),
                    decoration: BoxDecoration(
                      color: AppColors.secondry,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                    ),
                    child: const Icon(
                      SolarIconsBold.book,
                      color: AppColors.iconPrimary,
                      size: 24,
                    ),
                  ),
                  Text(
                    AppStrings.quranKareem,
                    style: AppTextStyles.font20W700White(context),
                  ),
                  const Spacer(),
                  const AppArrowIcon(
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        unawaited(AppFeedback.playLightHaptic());
        unawaited(context.pushNamed(AppRoutes.quran));
      },
    );
  }
}

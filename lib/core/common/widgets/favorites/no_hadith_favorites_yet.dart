import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class NoHadithFavoritesYet extends StatelessWidget {
  const NoHadithFavoritesYet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            SolarIconsOutline.heart,
            size: 80,
            color: AppColors.gold.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noFavoritesYet,
            style: AppTextStyles.font16W600Grey(context),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class QuranCardHeader extends StatelessWidget {
  const QuranCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            SolarIconsBold.book,
            color: AppColors.gold,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        Text('القرآن الكريم', style: AppTextStyles.font20W700White(context)),
        const Spacer(),
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.dailyContentFavorites),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gold, AppColors.gold.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'المفضلات',
              style: AppTextStyles.font12W700Black(
                context,
              ).copyWith(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

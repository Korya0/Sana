import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/cusotm_app_card_decoration.dart';
import 'package:solar_icons/solar_icons.dart';

class QuranCard extends StatelessWidget {
  const QuranCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: customAppCardDecoration(),
      child: Stack(
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
          GestureDetector(
            onTap: () => context.pushNamed(AppRoutes.quran),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                spacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      SolarIconsBold.book,
                      color: AppColors.gold,
                      size: 24,
                    ),
                  ),
                  Text(
                    'القرآن الكريم',
                    style: AppTextStyles.font20W700White(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

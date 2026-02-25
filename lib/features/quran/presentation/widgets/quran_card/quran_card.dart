import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_header.dart';

class QuranCard extends StatelessWidget {
  const QuranCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: QuranCardBackground.decoration,
      child: Stack(
        children: [
          const QuranCardBackground(),
          InkWell(
            onTap: () => context.pushNamed(AppRoutes.quran),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const QuranCardHeader(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Simple description at the far right
                      Text(
                        'تابع قرائتك اليومية',
                        style: AppTextStyles.font14W400WhiteHeight16(context),
                      ),
                      // Yellow Button at the far left
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'القرآن الكريم',
                          style: AppTextStyles.font12W600primary(context)
                              .copyWith(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ],
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

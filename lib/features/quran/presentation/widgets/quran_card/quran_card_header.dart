import 'package:flutter/material.dart';
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
      ],
    );
  }
}

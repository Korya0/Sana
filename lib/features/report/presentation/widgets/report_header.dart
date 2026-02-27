import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key, required this.isSuggestion});
  final bool isSuggestion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              isSuggestion
                  ? SolarIconsBold.lightbulb
                  : SolarIconsBold.dangerTriangle,
              color: AppColors.gold,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          isSuggestion ? 'شاركنا أفكارك' : 'ساعدنا في التحسين',
          style: AppTextStyles.font18W700White(context),
        ),
        const SizedBox(height: 8),
        Text(
          isSuggestion
              ? 'لديك فكرة رائعة؟ أخبرنا بها لتحسين التطبيق'
              : 'أخبرنا عن المشكلة التي واجهتك وسنعمل على حلها',
          style: AppTextStyles.font14W400Grey(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

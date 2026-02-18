import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class HadithSearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? bottomWidget;

  const HadithSearchEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: AppColors.gold),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTextStyles.font18W700White(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.font16W500Grey(context),
            textAlign: TextAlign.center,
          ),
          if (bottomWidget != null) ...[
            const SizedBox(height: 40),
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}

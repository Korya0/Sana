import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/home/presentation/widgets/category/custom_badge.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
    this.isRestricted = false,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isRestricted;
  @override
  Widget build(BuildContext context) {
    Widget card = customCard(context);

    if (isRestricted) {
      card = Stack(
        children: [
          card,
          const Positioned(
            top: 0,
            left: 0,
            child: CustomBadge(),
          ),
        ],
      );
    }

    return AppAnimations.pressScale(
      card,
      onTap: onTap,
    );
  }

  Container customCard(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: AppSpacing.v12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryBackground,
            AppColors.secondaryBackground.withValues(alpha: 0.8),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.iconPrimary,
            size: 26,
          ),
          const SizedBox(height: AppSpacing.v12),
          Text(
            title,
            style: AppTextStyles.font12W500White(context).copyWith(
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

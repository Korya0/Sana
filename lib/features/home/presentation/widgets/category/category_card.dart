import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

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
    return PressScaleWidget(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.secondaryBackground,
                    AppColors.secondaryBackground.withValues(alpha: 0.8),
                  ],
                ),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isRestricted ? Colors.grey : AppColors.gold,
                    size: 26,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: AppTextStyles.font12W500White(context).copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: isRestricted ? Colors.grey : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isRestricted)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    'غير متاح',
                    style: AppTextStyles.font12W700Black(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

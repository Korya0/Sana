import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class FeatureCircularCard extends StatelessWidget {
  const FeatureCircularCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isFaded = false,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isFaded;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.v8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
            child: Icon(
              icon,
              color: AppColors.iconPrimary,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.v8),
          Text(
            title,
            style: AppTextStyles.font12W500White(context).copyWith(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );

    return AppAnimations.pressScale(
      isFaded ? Opacity(opacity: 0.4, child: content) : content,
      onTap: onTap,
    );
  }
}

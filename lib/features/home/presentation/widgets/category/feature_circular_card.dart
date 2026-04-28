import 'package:flutter/material.dart';
import 'package:sana/core/common/animations/app_animations.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';

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
          decoration: featureCardDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isFaded
                ? AppColors.iconPrimary.withValues(alpha: 0.4)
                : AppColors.iconPrimary,
            size: 28,
          ),
        ),
        const SizedBox(height: AppSpacing.v8),
        Text(
          title,
          style: AppTextStyles.font12W500White(context).copyWith(
            color: isFaded ? Colors.white.withValues(alpha: 0.4) : null,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    return AppAnimations.pressScale(
      content,
      onTap: onTap,
    );
  }
}

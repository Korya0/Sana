import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:solar_icons/solar_icons.dart';

class SalawatOptionCard extends StatelessWidget {
  const SalawatOptionCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.content,
    super.key,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: featureCardDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: isSelected && content != null
                  ? const BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusM),
                    )
                  : BorderRadius.circular(AppSpacing.radiusM),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.v16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.font14W700White(context),
                    ),
                    if (isSelected)
                      Icon(
                        SolarIconsBold.checkCircle,
                        color: AppColors.iconPrimary,
                        size: 20.r(context),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelected && content != null) content!,
        ],
      ),
    );
  }
}

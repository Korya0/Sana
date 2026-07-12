import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
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
        context: context,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        color: isSelected
            ? context.color.primary.withValues(alpha: 0.15)
            : null,
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
                      style: AppTextStyles.font14W700(
                        context,
                      ).copyWith(color: context.color.textPrimary),
                    ),
                    if (isSelected)
                      Icon(
                        SolarIconsBold.checkCircle,
                        color: context.color.primary,
                        size: AppSpacing.s20.r(context),
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

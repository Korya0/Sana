import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        spacing: AppSpacing.v8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.v8),
            decoration: featureCardDecoration(
              context: context,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isFaded
                  ? context.color.primary.withValues(alpha: 0.4)
                  : context.color.primary,
              size: AppSpacing.s28.r(context),
            ),
          ),
          Text(
            title,
            style: AppTextStyles.font12W700(context).copyWith(
              color: isFaded
                  ? context.color.textSecondary
                  : context.color.textPrimary,
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

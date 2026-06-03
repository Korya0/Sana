import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
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
          decoration: featureCardDecoration(context: context, 
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isFaded
                ? context.color.primary.withValues(alpha: 0.4)
                : context.color.primary,
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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}


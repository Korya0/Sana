import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';

class AppCustomItemCard extends StatelessWidget {
  const AppCustomItemCard({
    required this.child,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    var decoration = featureCardDecoration(
      context: context,
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
    );

    if (isSelected) {
      decoration = decoration.copyWith(
        color: context.color.primary.withValues(alpha: 0.15),
        border: Border.all(
          color: context.color.primary.withValues(alpha: 0.5),
        ),
      );
    }

    return Container(
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.v12),
            child: child,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/common/decorations/custom_app_divider.dart';
import 'package:sana/core/common/decorations/feature_card_decoration.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class QiblaHeaderInfoWidget extends StatelessWidget {
  const QiblaHeaderInfoWidget({
    required this.distance,
    required this.direction,
    super.key,
  });

  final double distance;
  final double direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.v20),
      decoration: featureCardDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        color: AppColors.secondaryBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.v16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _InfoItem(
                icon: Icons.social_distance,
                label: AppStrings.distanceToMecca,
                value:
                    '${distance.toStringAsFixed(0)} ${AppStrings.distanceUnitKm}',
              ),
            ),
            const SizedBox(
              height: AppSpacing.v48,
              child: CustomAppDivider(isVertical: true),
            ),
            Expanded(
              child: _InfoItem(
                icon: Icons.explore,
                label: AppStrings.qiblaDirection,
                value: '${direction.toStringAsFixed(0)}${AppStrings.degreeSymbol}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.iconPrimary, size: 20.r(context)),
        const SizedBox(height: AppSpacing.v4),
        Text(label, style: AppTextStyles.font12W500Grey(context)),
        const SizedBox(height: AppSpacing.v2),
        Text(
          value,
          style: AppTextStyles.font14W600primary(context),
        ),
      ],
    );
  }
}

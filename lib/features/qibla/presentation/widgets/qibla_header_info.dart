import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QiblaInfo extends StatelessWidget {
  const QiblaInfo({required this.distance, required this.direction, super.key});
  final double distance;
  final double direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoItem(
            icon: Icons.social_distance,
            label: 'المسافة إلى مكة',
            value: '${distance.toStringAsFixed(0)} كم',
          ),
          Container(
            height: 40,
            width: 1,
            color: AppColors.gold.withValues(alpha: 0.2),
          ),
          _InfoItem(
            icon: Icons.explore,
            label: 'اتجاه القبلة',
            value: '${direction.toStringAsFixed(0)}°',
          ),
        ],
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
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.font12W500Grey(context)),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.font14W600White(
            context,
          ).copyWith(color: AppColors.gold),
        ),
      ],
    );
  }
}

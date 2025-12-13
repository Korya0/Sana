// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class QiblaInfo extends StatelessWidget {
  final double distance;
  final double direction;

  const QiblaInfo({super.key, required this.distance, required this.direction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: (20)),
      padding: EdgeInsets.all((16)),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular((16)),
        border: Border.all(color: AppColors.gold.withOpacity(0.2), width: 1),
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
            height: (40),
            width: 1,
            color: AppColors.gold.withOpacity(0.2),
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
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.gold, size: (20)),
        SizedBox(height: (4)),
        Text(label, style: AppTextStyles.font12W500Grey(context)),
        SizedBox(height: (2)),
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

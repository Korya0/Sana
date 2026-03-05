import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:solar_icons/solar_icons.dart';

class SettingsTileWidget extends StatelessWidget {
  const SettingsTileWidget({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(color: AppColors.secondaryBackground),
        child: Row(
          children: [
            Icon(icon, color: AppColors.iconWhite, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: AppTextStyles.font16W600White(context)),
            ),
            Icon(
              SolarIconsBold.altArrowLeft, // أو SolarIconsBold.altArrowRight
              color: AppColors.grey.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class SettingsTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: (16), vertical: (14)),
        decoration: const BoxDecoration(color: AppColors.secondaryBackground),
        child: Row(
          children: [
            Icon(icon, color: AppColors.iconWhite, size: (22)),
            const SizedBox(width: (16)),
            Expanded(
              child: Text(title, style: AppTextStyles.font16W600White(context)),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.grey.withOpacity(0.5),
              size: (16),
            ),
          ],
        ),
      ),
    );
  }
}

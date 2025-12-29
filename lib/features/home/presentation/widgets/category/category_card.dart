// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (100),
        padding: const EdgeInsets.all((12)),
        decoration: BoxDecoration(
          // Use a fixed semi-transparent color without blur
          color: const Color(
            0xB31E1E1E,
          ), // AppColors.secondaryBackground with 0.7 opacity roughly
          borderRadius: BorderRadius.circular((16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.gold, size: (28)),
            const SizedBox(height: (8)),
            Text(
              title,
              style: AppTextStyles.font12W500White(context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

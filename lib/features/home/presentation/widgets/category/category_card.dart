// ignore_for_file: deprecated_member_use

import 'dart:ui';
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

  static final _blurFilter = ImageFilter.blur(sigmaX: 5, sigmaY: 5);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular((16)),
        child: BackdropFilter(
          filter: _blurFilter,
          child: Container(
            width: (100),
            padding: EdgeInsets.all((12)),
            decoration: BoxDecoration(
              color: AppColors.secondaryBackground.withOpacity(0.6),
              borderRadius: BorderRadius.circular((16)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.gold, size: (28)),
                SizedBox(height: (8)),
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
        ),
      ),
    );
  }
}

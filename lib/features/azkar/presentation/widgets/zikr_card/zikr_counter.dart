// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class ZikrCounter extends StatelessWidget {
  final int remainingCount;
  final double progress;
  final bool isCompleted;

  const ZikrCounter({
    super.key,
    required this.remainingCount,
    required this.progress,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    const double size = (50);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress indicator
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: (3),
              backgroundColor: AppColors.gold.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.gold.withOpacity(
                  isCompleted ? 1.0 : 0.3 + (progress * 0.7),
                ),
              ),
            ),
          ),

          // Counter text - only the number
          Text(
            '$remainingCount',
            style: AppTextStyles.font20W700White(
              context,
            ).copyWith(fontSize: (28), color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}

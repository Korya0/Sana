import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class ConditionallyPrayerCardShowMessage extends StatelessWidget {
  const ConditionallyPrayerCardShowMessage({
    super.key,
    required this.message,
    this.onTap,
  });
  final String message;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        spacing: 4,
        children: [
          Text(
            message,
            style: AppTextStyles.font10W500Grey(
              context,
            ).copyWith(color: AppColors.textPrimary),
          ),
          Icon(Icons.info_outline, size: 18),
        ],
      ),
    );
  }
}

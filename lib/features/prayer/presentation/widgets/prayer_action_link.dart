import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
class PrayerActionLink extends StatelessWidget {
  const PrayerActionLink({
    required this.message,
    super.key,
    this.onTap,
  });
  final String message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        spacing: 4,
        children: [
          Text(
            message,
            style: AppTextStyles.font10W500primary(context),
          ),
          Icon(Icons.info_outline, color: context.color.primary, size: 18),
        ],
      ),
    );
  }
}


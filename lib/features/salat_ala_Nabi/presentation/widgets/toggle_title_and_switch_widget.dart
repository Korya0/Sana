// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class ToggleTitleAndSwitchWidget extends StatelessWidget {
  const ToggleTitleAndSwitchWidget({
    super.key,
    this.onChanged,
    required this.title,
    this.subtitle,
    required this.value,
  });

  final void Function(bool value)? onChanged;
  final String title;
  final String? subtitle;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.font16W600White(context)),
              if (subtitle != null)
                Text(subtitle!, style: AppTextStyles.font14W500Grey(context)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.gold,
          activeTrackColor: AppColors.gold.withOpacity(0.3),
        ),
      ],
    );
  }
}

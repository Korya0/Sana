import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class ToggleTitleAndSwitchWidget extends StatelessWidget {
  const ToggleTitleAndSwitchWidget({
    required this.title,
    required this.value,
    super.key,
    this.onChanged,
    this.subtitle,
  });

  final void Function({required bool value})? onChanged;
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
          onChanged: onChanged == null ? null : (v) => onChanged!(value: v),
          activeThumbColor: AppColors.gold,
          activeTrackColor: AppColors.gold.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

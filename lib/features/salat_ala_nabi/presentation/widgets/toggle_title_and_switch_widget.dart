import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
class ToggleTitleAndSwitchWidget extends StatelessWidget {
  const ToggleTitleAndSwitchWidget({
    required this.title,
    required this.value,
    super.key,
    this.onChanged,
  });

  final void Function({required bool value})? onChanged;
  final String title;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(title, style: AppTextStyles.font16W700White(context)),
        ),
        Switch(
          value: value,
          onChanged: onChanged == null ? null : (v) => onChanged!(value: v),
          activeThumbColor: context.color.primary,
          activeTrackColor: context.color.primary.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}

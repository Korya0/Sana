import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class SettingsTitleSection extends StatelessWidget {
  const SettingsTitleSection({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: AppTextStyles.font16W700(
          context,
        ).copyWith(color: context.color.textAccent),
      ),
    );
  }
}

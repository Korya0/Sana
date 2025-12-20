import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class SettingsTitleSection extends StatelessWidget {
  const SettingsTitleSection({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.horizontalP18),
      child: Text(title, style: AppTextStyles.font18W700White(context)),
    );
  }
}

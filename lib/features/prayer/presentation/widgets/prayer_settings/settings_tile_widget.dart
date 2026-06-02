import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/common/widgets/app_arrow_icon.dart';

class SettingsTileWidget extends StatelessWidget {
  const SettingsTileWidget({
    required this.title,
    required this.onTap,
    this.icon,
    super.key,
  });
  final IconData? icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: context.color.secondaryScaffoldBackgroundColor),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: context.color.textPrimary, size: 22),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(title, style: AppTextStyles.font16W700White(context)),
            ),
            const AppArrowIcon(
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}



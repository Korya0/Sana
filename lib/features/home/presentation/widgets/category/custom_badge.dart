import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: context.color.primary,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(4),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Text(
        AppStrings.notAccessible,
        style: AppTextStyles.font12W700Black(context),
      ),
    );
  }
}

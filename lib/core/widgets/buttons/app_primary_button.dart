import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: expand ? double.infinity : null,
    height: AppSize.h48,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: context.color.actionPrimary,
        foregroundColor: context.color.textOnPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.r16),
        ),
      ),
      child: Text(
        label,
        maxLines: AppConstants.maxOneLine,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.font14W700OnPrimary(context),
      ),
    ),
  );
}

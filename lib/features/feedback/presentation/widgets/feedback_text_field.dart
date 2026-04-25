import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class FeedbackTextField extends StatelessWidget {
  const FeedbackTextField({
    required this.controller,
    required this.hint,
    super.key,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines,
      cursorColor: AppColors.primary,
      keyboardType: keyboardType,
      style: AppTextStyles.font16W500White(context),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.font14W400Grey(context),
        filled: true,
        fillColor: AppColors.secondaryBackground,
        border: _border(AppColors.primary.withValues(alpha: 0.3)),
        enabledBorder: _border(AppColors.primary.withValues(alpha: 0.3)),
        focusedBorder: _border(AppColors.primary, width: 2),
        contentPadding: const EdgeInsets.all(AppSpacing.v16),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        borderSide: BorderSide(color: color, width: width),
      );
}

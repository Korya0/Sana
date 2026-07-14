import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    required this.hint,
    super.key,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.enabled = true,
    this.obscureText = false,
    this.textAlign = TextAlign.start,
    this.onFieldSubmitted,
    this.errorText,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool obscureText;
  final TextAlign textAlign;
  final ValueChanged<String>? onFieldSubmitted;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      textAlign: textAlign,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: context.color.primary,
      keyboardType: keyboardType,
      style: AppTextStyles.font14W500(
        context,
      ).copyWith(color: context.color.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.font14W500(
          context,
        ).copyWith(color: context.color.textSecondary),
        filled: true,
        fillColor: context.color.secondaryScaffoldBackgroundColor,
        errorText: errorText,
        contentPadding: const EdgeInsets.all(AppSpacing.v16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          borderSide: BorderSide(
            color: context.color.textPrimary.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          borderSide: BorderSide(
            color: context.color.textPrimary.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          borderSide: BorderSide(
            color: context.color.primary.withValues(alpha: 0.5),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          borderSide: BorderSide(
            color: context.color.error.withValues(alpha: 0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          borderSide: BorderSide(
            color: context.color.error,
          ),
        ),
      ),
    );
  }
}

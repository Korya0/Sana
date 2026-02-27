import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class ReportTextField extends StatelessWidget {
  const ReportTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: AppColors.gold,
      style: AppTextStyles.font16W500Grey(
        context,
      ).copyWith(color: AppColors.white),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.font14W400Grey(context),
        filled: true,
        fillColor: AppColors.secondaryBackground,
        border: _border(AppColors.gold.withValues(alpha: 0.3)),
        enabledBorder: _border(AppColors.gold.withValues(alpha: 0.3)),
        focusedBorder: _border(AppColors.gold, width: 2),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/inputs/app_text_field.dart';

class AppTextAreaField extends StatelessWidget {
  const AppTextAreaField({
    required this.controller,
    super.key,
    this.label,
    this.hint,
    this.hintText,
    this.focusNode,
    this.validator,
    this.maxLength = AppConstants.zikrTextMaxLength,
    this.onChanged,
    this.enabled = true,
    this.keyboardType = TextInputType.multiline,
    this.inputFormatters,
    this.minHeight,
    this.isRequired = false,
    this.isOptional = false,
  });

  final String? label;
  final String? hint;
  final String? hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? minHeight;
  final bool isRequired;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      hintText: hintText,
      focusNode: focusNode,
      validator: validator,
      maxLength: maxLength,
      onChanged: onChanged,
      isDisabled: !enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      minHeight: minHeight ?? AppSize.h150,
      isRequired: isRequired,
      isOptional: isOptional,
      maxLines: null,
      expands: true,
      showCharacterCount: true,
    );
  }
}

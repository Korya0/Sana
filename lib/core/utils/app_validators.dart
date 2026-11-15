import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_constants.dart';

class AppValidators {
  AppValidators._();

  static const int _nameMaxLength = AppConstants.nameMaxLength;

  // Input formatters — characters allowed as typed/pasted
  static final RegExp _arabicInputRegex = RegExp(
    r'[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF\s.,!?:;«»"()\u0027\-—_،؟؛]',
  );
  static final RegExp _digitsOnlyInputRegex = RegExp(r'[0-9٠-٩]');

  static List<TextInputFormatter> get arabicInputFormatters => [
    FilteringTextInputFormatter.allow(_arabicInputRegex),
  ];

  static List<TextInputFormatter> get arabicNameInputFormatters => [
    FilteringTextInputFormatter.allow(_arabicInputRegex),
    LengthLimitingTextInputFormatter(_nameMaxLength),
  ];

  static List<TextInputFormatter> get digitsOnlyInputFormatters => [
    FilteringTextInputFormatter.allow(_digitsOnlyInputRegex),
    const _NoLeadingZeroTextInputFormatter(),
    LengthLimitingTextInputFormatter(3),
  ];

  // Required
  static String? requiredField(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) return errorMessage;
    return null;
  }

  /// Normalizes Arabic-Indic digits to ASCII digits.
  static String normalizeDigits(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = input;
    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(arabicDigits[i], '$i');
    }
    return result;
  }

  /// Parses integer count from Western or Arabic-Indic digits string.
  static int? parseCount(String input) {
    final normalized = normalizeDigits(input.trim());
    return int.tryParse(normalized);
  }

  /// Validates target count: required and > 0 (non-digits are strictly blocked by inputFormatters).
  static String? targetCount(
    String? value, {
    required String emptyError,
    required String greaterThanZeroError,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyError;
    final count = parseCount(trimmed);
    if (count == null || count <= 0) return greaterThanZeroError;
    return null;
  }
}

class _NoLeadingZeroTextInputFormatter extends TextInputFormatter {
  const _NoLeadingZeroTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Strip leading zeros (Western '0' and Arabic-Indic '٠')
    if (newValue.text.startsWith('0') || newValue.text.startsWith('٠')) {
      final stripped = newValue.text.replaceFirst(RegExp(r'^[0٠]+'), '');
      if (stripped.isEmpty) {
        // Keep a lone zero so validation reports "greater than zero" instead
        // of falling back to "required" on an emptied field.
        return newValue;
      }
      return TextEditingValue(
        text: stripped,
        selection: TextSelection.collapsed(offset: stripped.length),
      );
    }

    return newValue;
  }
}

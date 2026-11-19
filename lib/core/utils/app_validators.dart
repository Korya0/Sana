import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_constants.dart';

class AppValidators {
  AppValidators._();

  // Input formatters — characters allowed as typed/pasted
  static final RegExp _arabicInputRegex = RegExp(
    r'[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF\s.,!?:;«»"()\u0027\-—_،؟؛]',
  );
  static final RegExp _digitsOnlyInputRegex = RegExp(r'[0-9٠-٩]');
  static final RegExp _arabicLettersRegex = RegExp(
    r'[\u0621-\u063A\u0641-\u064A\u064B-\u065F\u066E-\u066F\u0671-\u06D3\u06D5\u06EE-\u06EF\u06FA-\u06FC\u06FF]',
  );
  static final RegExp _arabicNameCharsRegex = RegExp(
    r'[\u0621-\u063A\u0641-\u064A\u064B-\u065F\u066E-\u066F\u0671-\u06D3\u06D5\u06EE-\u06EF\u06FA-\u06FC\u06FF\s]',
  );
  static final RegExp _whitespaceRegex = RegExp(r'\s+');

  static List<TextInputFormatter> get arabicInputFormatters => [
    FilteringTextInputFormatter.allow(_arabicInputRegex),
  ];

  static List<TextInputFormatter> get arabicNameInputFormatters => [
    FilteringTextInputFormatter.allow(_arabicNameCharsRegex),
    LengthLimitingTextInputFormatter(AppConstants.nameMaxLength),
  ];

  static List<TextInputFormatter> get digitsOnlyInputFormatters =>
      _digitsOnlyFormatters(AppConstants.targetCountMaxDigits);

  static List<TextInputFormatter> get tasbeehCountInputFormatters =>
      _digitsOnlyFormatters(AppConstants.targetCountMaxDigits);

  static List<TextInputFormatter> _digitsOnlyFormatters(int maxDigits) => [
    FilteringTextInputFormatter.allow(_digitsOnlyInputRegex),
    const _NoLeadingZeroTextInputFormatter(),
    LengthLimitingTextInputFormatter(maxDigits),
  ];

  // Required
  static String? requiredField(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) return errorMessage;
    return null;
  }

  // Collapses repeated whitespace for comparison and storage.
  static String collapseWhitespace(String value) =>
      value.trim().replaceAll(_whitespaceRegex, ' ');

  // Rejects values made only of punctuation or digits.
  static String? arabicLetters(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_arabicLettersRegex.hasMatch(value)) return errorMessage;
    return null;
  }

  // Enforces a minimum number of Arabic letters, not just characters.
  static String? minLetters(
    String? value,
    int min,
    String errorMessage,
  ) {
    if (value == null || value.trim().isEmpty) return null;
    if (_arabicLettersRegex.allMatches(value).length < min) {
      return errorMessage;
    }
    return null;
  }

  // Rejects a value already used by another item.
  static String? duplicate(
    String? value,
    Set<String> existing,
    String errorMessage,
  ) {
    if (value == null || value.trim().isEmpty) return null;
    final candidate = collapseWhitespace(value);
    if (existing.any((item) => collapseWhitespace(item) == candidate)) {
      return errorMessage;
    }
    return null;
  }

  // Normalizes Arabic-Indic digits
  static String _normalizeDigits(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = input;
    for (var i = 0; i < 10; i++) {
      result = result.replaceAll(arabicDigits[i], '$i');
    }
    return result;
  }

  // Parses count
  static int? parseCount(String input) {
    final normalized = _normalizeDigits(input.trim());
    return int.tryParse(normalized);
  }

  /// Validates target count: required and > 0 (non-digits are strictly blocked by inputFormatters).
  static String? targetCount(
    String? value, {
    required String emptyError,
    required String greaterThanZeroError,
    int? max,
    String? maxError,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyError;
    final count = parseCount(trimmed);
    if (count == null || count <= 0) return greaterThanZeroError;
    if (max != null && count > max) return maxError ?? greaterThanZeroError;
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

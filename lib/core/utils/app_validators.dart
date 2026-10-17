import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_constants.dart';

class AppValidators {
  AppValidators._();

  static const int _otpLength = AppConstants.otpLength;
  static const int _nameMaxLength = AppConstants.nameMaxLength;
  static const int _emailMaxLength = AppConstants.emailMaxLength;
  static const int _passwordMaxLength = AppConstants.passwordMaxLength;
  static const int _passwordMinLength = AppConstants.passwordMediumLength;
  static const int _phoneMaxLength = AppConstants.phoneMaxLength;

  // Regex
  static final RegExp _arabicRegex = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]',
  );
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _numberRegex = RegExp(r'\d');
  static final RegExp _specialCharRegex = RegExp(r'[^A-Za-z0-9]');
  static final RegExp _whitespaceRegex = RegExp(r'\s');
  static final RegExp _multipleSpacesRegex = RegExp(r'\s{2,}');
  static final RegExp _otpRegex = RegExp('^\\d{$_otpLength}\$');
  static final RegExp _phoneRegex = RegExp(r'^\+?[1-9]\d{7,14}$');
  static final RegExp _nameCharsRegex = RegExp(
    r'^[A-Za-z\u0600-\u065F\u066A-\u06EF\u06FA-\u06FF\s]+$',
  );
  static final RegExp _localPartRegex = RegExp(
    r"^[A-Za-z0-9!#$%&'*+/=?^_`{|}~.-]+$",
  );
  static final RegExp _domainSegmentRegex = RegExp(r'^[A-Za-z0-9-]+$');
  static final RegExp _tldRegex = RegExp(r'^[A-Za-z]{2,}$');

  // Input formatters
  static List<TextInputFormatter> get nameInputFormatters => [
    FilteringTextInputFormatter.allow(_nameCharsRegex),
    LengthLimitingTextInputFormatter(_nameMaxLength),
  ];

  static List<TextInputFormatter> get emailInputFormatters => [
    ..._withoutWhitespaceOrArabic(),
    LengthLimitingTextInputFormatter(_emailMaxLength),
  ];

  static List<TextInputFormatter> get passwordInputFormatters => [
    ..._withoutWhitespaceOrArabic(),
    LengthLimitingTextInputFormatter(_passwordMaxLength),
  ];

  static List<TextInputFormatter> get phoneInputFormatters =>
      _digitsOnly(_phoneMaxLength);

  static List<TextInputFormatter> get otpInputFormatters => _digitsOnly(1);

  static List<TextInputFormatter> _withoutWhitespaceOrArabic() => [
    FilteringTextInputFormatter.deny(_whitespaceRegex),
    FilteringTextInputFormatter.deny(_arabicRegex),
  ];

  static List<TextInputFormatter> _digitsOnly(int maxLength) => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(maxLength),
  ];

  static bool _hasArabic(String value) => _arabicRegex.hasMatch(value);
  static bool _hasUppercase(String value) => _uppercaseRegex.hasMatch(value);
  static bool _hasNumber(String value) => _numberRegex.hasMatch(value);
  static bool _hasSpecialCharacter(String value) =>
      _specialCharRegex.hasMatch(value);
  static bool _hasWhitespace(String value) => _whitespaceRegex.hasMatch(value);

  // Required
  static String? requiredField(String? value, String errorMessage) {
    if (value == null || value.trim().isEmpty) return errorMessage;
    return null;
  }

  /// Required with min length.
  static String? minLengthText(
    String? value, {
    required String emptyError,
    required String tooShortError,
    required int minLength,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyError;
    if (trimmed.length < minLength) return tooShortError;
    return null;
  }

  static String? name(
    String? value, {
    required String emptyError,
    required String lengthError,
    String? tooFewWordsError,
    String? multipleSpacesError,
    String? invalidError,
  }) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) return emptyError;
    if (_multipleSpacesRegex.hasMatch(trimmed)) {
      return multipleSpacesError ?? lengthError;
    }
    if (trimmed.length > _nameMaxLength) return lengthError;
    if (!_nameCharsRegex.hasMatch(trimmed)) {
      return invalidError ?? lengthError;
    }

    return null;
  }

  static String? email(
    String? value, {
    required String emptyError,
    required String invalidError,
  }) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) return emptyError;
    if (trimmed.length > _emailMaxLength) return invalidError;
    if (_hasArabic(trimmed) || _hasWhitespace(trimmed)) return invalidError;

    final parts = trimmed.split('@');
    if (parts.length != 2) return invalidError;

    final localPart = parts[0];
    final domainPart = parts[1];

    if (localPart.isEmpty || domainPart.isEmpty) return invalidError;
    if (localPart.startsWith('.') ||
        localPart.endsWith('.') ||
        localPart.contains('..')) {
      return invalidError;
    }
    if (domainPart.startsWith('.') ||
        domainPart.endsWith('.') ||
        domainPart.contains('..')) {
      return invalidError;
    }
    if (!_localPartRegex.hasMatch(localPart)) return invalidError;

    final domainSegments = domainPart.split('.');
    if (domainSegments.length < 2 ||
        domainSegments.any((segment) => segment.isEmpty)) {
      return invalidError;
    }

    for (final segment in domainSegments) {
      if (!_domainSegmentRegex.hasMatch(segment)) return invalidError;
      if (segment.startsWith('-') || segment.endsWith('-')) return invalidError;
    }

    if (!_tldRegex.hasMatch(domainSegments.last)) return invalidError;

    return null;
  }

  static String? password(
    String? value, {
    required String emptyError,
    required String lengthError,
    required String uppercaseError,
    required String numberError,
    required String specialCharacterError,
    String? arabicError,
  }) {
    if (value == null || value.isEmpty) return emptyError;
    if (_hasWhitespace(value)) return lengthError;
    if (_hasArabic(value)) return arabicError ?? lengthError;
    if (value.length < _passwordMinLength ||
        value.length > _passwordMaxLength) {
      return lengthError;
    }
    if (!_hasUppercase(value)) return uppercaseError;
    if (!_hasNumber(value)) return numberError;
    if (!_hasSpecialCharacter(value)) return specialCharacterError;
    return null;
  }

  static String? confirmPassword(
    String? value,
    String original, {
    required String emptyError,
    required String mismatchError,
    String? arabicError,
  }) {
    if (value == null || value.isEmpty) return emptyError;
    if (_hasWhitespace(value)) return arabicError ?? mismatchError;
    if (_hasArabic(value)) return arabicError ?? mismatchError;
    if (value.length > _passwordMaxLength) return mismatchError;
    if (value != original) return mismatchError;
    return null;
  }

  static String? phone(
    String? value, {
    required String emptyError,
    required String invalidError,
  }) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) return emptyError;
    if (_hasWhitespace(trimmed)) return invalidError;
    if (!_phoneRegex.hasMatch(trimmed)) return invalidError;

    return null;
  }

  static String? otp(
    String? value, {
    required String emptyError,
    required String invalidError,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyError;
    if (!_otpRegex.hasMatch(trimmed)) return invalidError;
    return null;
  }

  /// Password strength score.
  static int calculatePasswordStrengthScore(String value) {
    if (value.isEmpty) return 0;
    if (value.length < AppConstants.passwordWeakLength) return 1;

    final hasUpper = _hasUppercase(value);
    final hasNumber = _hasNumber(value);
    final hasSpecial = _hasSpecialCharacter(value);

    if (value.length >= AppConstants.passwordMediumLength &&
        hasUpper &&
        hasNumber &&
        hasSpecial) {
      return 3;
    }
    return 2;
  }
}

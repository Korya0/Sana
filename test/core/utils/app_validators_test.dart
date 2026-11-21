import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/utils/app_validators.dart';

void main() {
  group('requiredField', () {
    test('rejects null and empty values', () {
      expect(AppValidators.requiredField(null, 'required'), 'required');
      expect(AppValidators.requiredField('', 'required'), 'required');
    });

    test('rejects whitespace-only values', () {
      expect(AppValidators.requiredField('   ', 'required'), 'required');
      expect(AppValidators.requiredField('\n\t', 'required'), 'required');
    });

    test('accepts a non-empty value after trimming', () {
      expect(AppValidators.requiredField('  ذكر  ', 'required'), isNull);
    });
  });

  group('parseCount', () {
    test('parses Western digits', () {
      expect(AppValidators.parseCount('123'), 123);
    });

    test('parses Arabic-Indic digits', () {
      expect(AppValidators.parseCount('١٢٣'), 123);
    });

    test('trims surrounding whitespace', () {
      expect(AppValidators.parseCount('  42  '), 42);
    });

    test('parses leading zeros as a number', () {
      expect(AppValidators.parseCount('0042'), 42);
      expect(AppValidators.parseCount('٠٠٤٢'), 42);
    });

    test('returns null for empty, non-numeric and mixed values', () {
      expect(AppValidators.parseCount(''), isNull);
      expect(AppValidators.parseCount('   '), isNull);
      expect(AppValidators.parseCount('abc'), isNull);
      expect(AppValidators.parseCount('12a'), isNull);
    });
  });

  group('targetCount', () {
    const emptyError = 'required';
    const zeroError = 'greater than zero';

    test('rejects null, empty and whitespace as empty', () {
      for (final value in [null, '', '   ']) {
        expect(
          AppValidators.targetCount(
            value,
            emptyError: emptyError,
            greaterThanZeroError: zeroError,
          ),
          emptyError,
        );
      }
    });

    test('rejects zero and negative values', () {
      for (final value in ['0', '٠', '-5']) {
        expect(
          AppValidators.targetCount(
            value,
            emptyError: emptyError,
            greaterThanZeroError: zeroError,
          ),
          zeroError,
        );
      }
    });

    test('accepts positive Western and Arabic-Indic values', () {
      expect(
        AppValidators.targetCount(
          '33',
          emptyError: emptyError,
          greaterThanZeroError: zeroError,
        ),
        isNull,
      );
      expect(
        AppValidators.targetCount(
          '٣٣',
          emptyError: emptyError,
          greaterThanZeroError: zeroError,
        ),
        isNull,
      );
    });

    test('rejects non-numeric values as invalid', () {
      expect(
        AppValidators.targetCount(
          'abc',
          emptyError: emptyError,
          greaterThanZeroError: zeroError,
        ),
        zeroError,
      );
    });
  });

  group('arabicInputFormatters', () {
    test('keeps Arabic letters, spaces and allowed punctuation', () {
      expect(
        _format('ذكر، سبحان الله!', AppValidators.arabicInputFormatters).text,
        'ذكر، سبحان الله!',
      );
    });

    test('filters Latin letters and digits', () {
      expect(
        _format('abc123', AppValidators.arabicInputFormatters).text,
        '',
      );
    });
  });

  group('arabicNameInputFormatters', () {
    test('keeps Arabic letters and limits the length', () {
      final value = _format(
        'ا' * (AppConstants.nameMaxLength + 20),
        AppValidators.arabicNameInputFormatters,
      );

      expect(value.text.length, AppConstants.nameMaxLength);
    });
  });

  group('digitsOnlyInputFormatters', () {
    test('strips leading Western zeros', () {
      expect(
        _format('0042', AppValidators.digitsOnlyInputFormatters).text,
        '42',
      );
    });

    test('strips leading Arabic-Indic zeros', () {
      expect(
        _format('٠٠٤٢', AppValidators.digitsOnlyInputFormatters).text,
        '٤٢',
      );
    });

    test('keeps a lone zero so validation can report it', () {
      expect(
        _format('0', AppValidators.digitsOnlyInputFormatters).text,
        '0',
      );
      expect(
        _format('٠', AppValidators.digitsOnlyInputFormatters).text,
        '٠',
      );
    });

    test('keeps an all-zero value instead of emptying the field', () {
      expect(
        _format('000', AppValidators.digitsOnlyInputFormatters).text,
        '000',
      );
    });

    test('limits the value to four digits', () {
      expect(
        _format('12345', AppValidators.digitsOnlyInputFormatters).text,
        '1234',
      );
    });

    test('uses the same digit limit as tasbeeh targets', () {
      final azkarValue = _format(
        '123456',
        AppValidators.digitsOnlyInputFormatters,
      ).text;
      final tasbeehValue = _format(
        '123456',
        AppValidators.tasbeehCountInputFormatters,
      ).text;

      expect(azkarValue, tasbeehValue);
      expect(azkarValue, '1234');
    });

    test('filters non-digit characters', () {
      expect(
        _format('1a2ب3', AppValidators.digitsOnlyInputFormatters).text,
        '123',
      );
    });
  });

  group('tasbeehCountInputFormatters', () {
    test('allows four digits and strips leading zeros', () {
      expect(
        _format('00042', AppValidators.tasbeehCountInputFormatters).text,
        '42',
      );
      expect(
        _format('12345', AppValidators.tasbeehCountInputFormatters).text,
        '1234',
      );
    });

    test('keeps a lone zero', () {
      expect(
        _format('0', AppValidators.tasbeehCountInputFormatters).text,
        '0',
      );
    });
  });

  group('text validation', () {
    test('minLetters counts Arabic letters, not punctuation', () {
      expect(AppValidators.minLetters('؟؟؟', 3, 'short'), 'short');
      expect(AppValidators.minLetters('ا', 3, 'short'), 'short');
      expect(AppValidators.minLetters('سبحان', 3, 'short'), isNull);
    });

    test('arabicLetters rejects punctuation-only values', () {
      expect(AppValidators.arabicLetters('؟', 'letters'), 'letters');
      expect(AppValidators.arabicLetters('سبحان الله', 'letters'), isNull);
    });

    test('duplicate ignores whitespace differences', () {
      expect(
        AppValidators.duplicate('  سبحان   الله ', {'سبحان الله'}, 'duplicate'),
        'duplicate',
      );
      expect(
        AppValidators.duplicate('الحمد لله', {'سبحان الله'}, 'duplicate'),
        isNull,
      );
    });

    test('collapseWhitespace trims and collapses repeated spaces', () {
      expect(
        AppValidators.collapseWhitespace('  ذكر    جديد\n ومفيد  '),
        'ذكر جديد ومفيد',
      );
    });

    test('targetCount enforces an optional maximum', () {
      expect(
        AppValidators.targetCount(
          '10000',
          emptyError: 'empty',
          greaterThanZeroError: 'positive',
          max: 9999,
          maxError: 'max',
        ),
        'max',
      );
      expect(
        AppValidators.targetCount(
          '9999',
          emptyError: 'empty',
          greaterThanZeroError: 'positive',
          max: 9999,
          maxError: 'max',
        ),
        isNull,
      );
    });

    test('name formatter drops digits and punctuation', () {
      expect(
        _format('أحمد1؟', AppValidators.arabicNameInputFormatters).text,
        'أحمد',
      );
    });
  });
}

TextEditingValue _format(
  String text,
  List<TextInputFormatter> formatters,
) {
  var oldValue = TextEditingValue.empty;
  var newValue = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );
  for (final formatter in formatters) {
    newValue = formatter.formatEditUpdate(oldValue, newValue);
    oldValue = newValue;
  }
  return newValue;
}

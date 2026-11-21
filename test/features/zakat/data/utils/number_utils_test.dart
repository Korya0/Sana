import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

void main() {
  group('NumberUtils', () {
    test('parses Arabic-Indic digits and separators', () {
      expect(NumberUtils.parseAmount('٥٬٠٠٠'), 5000);
      expect(NumberUtils.parseAmount('١٢٣٫٤٥'), 123.45);
    });

    test('parses Eastern Arabic-Indic digits and separators', () {
      expect(NumberUtils.parseAmount('۱٬۲۳۴'), 1234);
      expect(NumberUtils.parseAmount('5,000'), 5000);
    });

    test('returns zero for empty input and null for invalid input', () {
      expect(NumberUtils.parseAmount(''), 0);
      expect(NumberUtils.parseAmount(null), 0);
      expect(NumberUtils.parseAmount('abc'), isNull);
      expect(NumberUtils.parseAmount('-5'), isNull);
    });

    test('formats amounts with thousands separators', () {
      expect(NumberUtils.formatAmount(1234567), '1,234,567');
      expect(NumberUtils.formatAmount(1234.5), '1,234.50');
    });
  });
}

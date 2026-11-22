import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/services/zakat_calculator.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

void main() {
  group('ZakatCurrency', () {
    test('covers a broad list with Arabic labels and ISO codes', () {
      expect(
        ZakatCurrency.values.map((c) => c.code),
        containsAll([
          'EGP',
          'USD',
          'SAR',
          'AED',
          'EUR',
          'KWD',
          'GBP',
          'TRY',
        ]),
      );
      expect(ZakatCurrency.saudiRiyal.label, 'ريال سعودي');
      expect(ZakatCurrency.saudiRiyal.suffix, 'ريال');
      expect(ZakatCurrency.saudiRiyal.menuLabel, 'ريال سعودي (SAR)');
    });

    test('the selected currency is carried through the calculation result', () {
      final result = ZakatCalculator.calculate(
        ZakatInput(
          currency: ZakatCurrency.saudiRiyal,
          cash: 500000,
          goldPricePerGram: 5000,
          hawlCompleted: true,
          priceDate: DateTime(2026),
        ),
      );

      expect(result.currency, ZakatCurrency.saudiRiyal);
      expect(result.input.currency, ZakatCurrency.saudiRiyal);
      expect(
        NumberUtils.formatMoney(result.zakatAmount, currency: result.currency),
        '12,500 ريال',
      );
    });

    test('defaults to EGP so existing amounts keep their original suffix', () {
      expect(
        NumberUtils.formatMoney(12500),
        '12,500 جنيه',
      );
    });
  });
}

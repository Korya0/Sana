import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/services/zakat_calculator.dart';

void main() {
  final now = DateTime(2026);

  ZakatInput buildInput({
    double cash = 0,
    double goldGrams = 0,
    int goldKarat = 21,
    double? goldPrice = 5000,
    bool hawlCompleted = true,
    bool goldIsPersonalUse = false,
    bool includePersonalGold = false,
  }) {
    return ZakatInput(
      cash: cash,
      goldGrams: goldGrams,
      goldKarat: goldKarat,
      goldPricePerGram: goldPrice,
      hawlCompleted: hawlCompleted,
      goldIsPersonalUse: goldIsPersonalUse,
      includePersonalGold: includePersonalGold,
      standard: NisabStandard.gold,
      priceDate: now,
    );
  }

  group('ZakatCalculator', () {
    test('calculates the example: 100g of 21k gold at 5000 per gram', () {
      final result = ZakatCalculator.calculate(buildInput(goldGrams: 100));

      expect(result.status, ZakatStatus.due);
      expect(result.goldValue, 500000);
      expect(result.goldPureGrams, 87.5);
      expect(result.nisabValue, 485714.29);
      expect(result.netAmount, 500000);
      expect(result.zakatAmount, 12500);
    });

    test('reports belowNisab when net wealth is below the threshold', () {
      final result = ZakatCalculator.calculate(buildInput(cash: 1000));

      expect(result.status, ZakatStatus.belowNisab);
      expect(result.zakatAmount, 0);
    });

    test('reports nisabUnknown when the required metal price is missing', () {
      final result = ZakatCalculator.calculate(
        buildInput(goldGrams: 100, goldPrice: null),
      );

      expect(result.status, ZakatStatus.nisabUnknown);
      expect(result.nisabValue, isNull);
    });

    test(
      'uses visible live prices even when every amount field is empty',
      () {
        final livePrices = MetalPrices(
          pureGoldPricePerGram: 6000,
          silverPricePerGram: 50,
          fetchedAt: now,
        );
        final result = ZakatCalculator.calculate(
          ZakatInput(
            cash: 0,
            goldGrams: 0,
            goldKarat: 21,
            goldPricePerGram: livePrices.priceForKarat(21),
            silverPricePerGram: livePrices.silverPricePerGram,
            hawlCompleted: true,
            standard: NisabStandard.gold,
            priceDate: now,
          ),
        );

        expect(result.status, isNot(ZakatStatus.nisabUnknown));
        expect(result.status, ZakatStatus.belowNisab);
        expect(result.nisabValue, 510000);
      },
    );

    test('excludes personal gold when the user opts out', () {
      final result = ZakatCalculator.calculate(
        buildInput(
          cash: 600000,
          goldGrams: 100,
          goldIsPersonalUse: true,
          includePersonalGold: false,
        ),
      );

      expect(result.status, ZakatStatus.due);
      expect(result.goldValue, 0);
      expect(result.excludedPersonalGold, 500000);
      expect(result.netAmount, 600000);
    });

    test('converts gold prices between karats without changing pure value', () {
      final purePrice = NisabCalculator.pureGoldPrice(5000, 21);

      expect(purePrice, closeTo(5714.2857, 0.001));
      expect(purePrice! * 18 / GoldKarats.pure, closeTo(4285.7143, 0.001));
    });
  });
}

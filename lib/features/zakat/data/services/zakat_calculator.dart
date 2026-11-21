import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'nisab_calculator.dart';

export 'nisab_calculator.dart';

/// منطق حساب زكاة المال وفق الضوابط الشرعية.
class ZakatCalculator {
  ZakatCalculator._();

  static const double rate = 0.025;
  static const double goldNisabGrams = NisabCalculator.goldNisabGrams;
  static const double silverNisabGrams = NisabCalculator.silverNisabGrams;

  static double nisabGrams(NisabStandard s) => NisabCalculator.nisabGrams(s);
  static double pureGoldGrams(double g, int k) =>
      NisabCalculator.pureGoldGrams(g, k);
  static double? pureGoldPrice(double? p, int k) =>
      NisabCalculator.pureGoldPrice(p, k);
  static double? nisabValue({
    required NisabStandard standard,
    double? goldPricePerGram,
    int goldKarat = GoldKarats.pure,
    double? silverPricePerGram,
  }) => NisabCalculator.nisabValue(
    standard: standard,
    goldPricePerGram: goldPricePerGram,
    goldKarat: goldKarat,
    silverPricePerGram: silverPricePerGram,
  );

  static ZakatResult calculate(ZakatInput input) {
    final bool skipGold = input.goldIsPersonalUse && !input.includePersonalGold;
    final double goldGrams = skipGold ? 0 : input.goldGrams;
    final double? goldVal = NisabCalculator.metalValue(
      goldGrams,
      input.goldPricePerGram,
    );
    final double? silverVal = NisabCalculator.metalValue(
      input.silverGrams,
      input.silverPricePerGram,
    );

    final bool missingPrice =
        (goldGrams > 0 && goldVal == null) ||
        (input.silverGrams > 0 && silverVal == null);

    final double total =
        input.cash +
        (goldVal ?? 0) +
        (silverVal ?? 0) +
        input.tradeGoods +
        input.receivableDebts;
    final double deductions = input.liabilities > total
        ? total
        : input.liabilities;
    final double net = total - deductions;

    final double? nisab = nisabValue(
      standard: input.standard,
      goldPricePerGram: input.goldPricePerGram,
      goldKarat: input.goldKarat,
      silverPricePerGram: input.silverPricePerGram,
    );

    final double excludedVal = (skipGold && input.goldPricePerGram != null)
        ? input.goldGrams * input.goldPricePerGram!
        : 0;

    ZakatStatus status = ZakatStatus.due;
    double zakat = 0;
    if (missingPrice || nisab == null) {
      status = ZakatStatus.nisabUnknown;
    } else if (net < nisab) {
      status = ZakatStatus.belowNisab;
    } else if (!input.hawlCompleted) {
      status = ZakatStatus.hawlNotCompleted;
    } else {
      zakat = _round2(net * rate);
    }

    return ZakatResult(
      input: input,
      totalAssets: _round2(total),
      appliedDeductions: _round2(deductions),
      netAmount: _round2(net),
      nisabValue: nisab == null ? null : _round2(nisab),
      status: status,
      zakatAmount: zakat,
      excludedPersonalGold: _round2(excludedVal),
      goldValue: _round2(goldVal ?? 0),
      silverValue: _round2(silverVal ?? 0),
      goldPureGrams: _round2(pureGoldGrams(goldGrams, input.goldKarat)),
    );
  }

  static double _round2(double v) => (v * 100).round() / 100;
}

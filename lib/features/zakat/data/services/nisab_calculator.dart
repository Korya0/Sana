import 'package:sana/features/zakat/data/models/zakat_input.dart';

/// حسابات النصاب وتحويل عيارات الذهب والفضة.
class NisabCalculator {
  NisabCalculator._();

  /// نصاب الذهب بالجرام (ذهب خالص عيار 24).
  static const double goldNisabGrams = 85;

  /// نصاب الفضة بالجرام (تقدير شائع لمئتي درهم).
  static const double silverNisabGrams = 595;

  static double nisabGrams(NisabStandard standard) =>
      standard == NisabStandard.gold ? goldNisabGrams : silverNisabGrams;

  /// يحوّل وزن ذهب من عيار معين إلى ما يعادله من الذهب الخالص (عيار 24).
  static double pureGoldGrams(double grams, int karat) {
    if (grams <= 0 || karat <= 0) return 0;
    return grams * karat / GoldKarats.pure;
  }

  /// يحوّل سعر جرام ذهب من عيار معين إلى سعر الجرام الخالص.
  static double? pureGoldPrice(double? priceOfKarat, int karat) {
    if (priceOfKarat == null || priceOfKarat <= 0 || karat <= 0) return null;
    return priceOfKarat * GoldKarats.pure / karat;
  }

  /// قيمة النصاب بعملة الحساب المختارة، أو null إذا لم يتوفر سعر صالح.
  static double? nisabValue({
    required NisabStandard standard,
    double? goldPricePerGram,
    int goldKarat = GoldKarats.pure,
    double? silverPricePerGram,
  }) {
    if (standard == NisabStandard.gold) {
      final purePrice = pureGoldPrice(goldPricePerGram, goldKarat);
      if (purePrice == null) return null;
      return goldNisabGrams * purePrice;
    }
    if (silverPricePerGram == null || silverPricePerGram <= 0) return null;
    return silverNisabGrams * silverPricePerGram;
  }

  /// قيمة وزن معدن بسعر جرامه. يعيد null إذا كان الوزن موجودًا بلا سعر.
  static double? metalValue(double grams, double? pricePerGram) {
    if (grams <= 0) return 0;
    if (pricePerGram == null || pricePerGram <= 0) return null;
    return grams * pricePerGram;
  }
}

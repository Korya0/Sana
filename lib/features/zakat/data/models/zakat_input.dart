/// المعيار المعتمد لحساب النصاب.
enum NisabStandard {
  gold('الذهب'),
  silver('الفضة');

  const NisabStandard(this.label);
  final String label;
}

/// العيارات الشائعة للذهب. العيار 24 هو الذهب الخالص.
class GoldKarats {
  GoldKarats._();

  static const int pure = 24;

  /// العيارات المعروضة في التطبيق.
  static const List<int> common = [24, 22, 21, 18, 14];
}

/// مدخلات حساب الزكاة. جميع المبالغ بالجنيه المصري.
class ZakatInput {
  const ZakatInput({
    this.cash = 0,
    this.goldGrams = 0,
    this.goldKarat = 21,
    this.goldPricePerGram,
    this.silverGrams = 0,
    this.silverPricePerGram,
    this.goldIsPersonalUse = false,
    this.includePersonalGold = false,
    this.tradeGoods = 0,
    this.receivableDebts = 0,
    this.liabilities = 0,
    this.hawlCompleted = false,
    this.standard = NisabStandard.gold,
    required this.priceDate,
  });

  /// الأموال النقدية والمدخرات والأرصدة البنكية.
  final double cash;

  /// وزن الذهب الذي يملكه المستخدم بالجرام.
  final double goldGrams;

  /// عيار الذهب المدخل (24 = خالص).
  final int goldKarat;

  /// سعر جرام الذهب بالعيار المدخل، بالجنيه.
  /// null يعني أن المستخدم لم يُدخل السعر.
  final double? goldPricePerGram;

  /// وزن الفضة التي يملكها المستخدم بالجرام.
  final double silverGrams;

  /// سعر جرام الفضة النقية بالجنيه.
  /// null يعني أن المستخدم لم يُدخل السعر.
  final double? silverPricePerGram;

  /// هل الذهب/الفضة مقتنى للاستعمال الشخصي (حلي ونحوه)؟
  final bool goldIsPersonalUse;

  /// إذا كان الذهب للاستعمال الشخصي: هل يريد المستخدم إدخاله في الحساب؟
  /// (مسألة خلافية بين الفقهاء).
  final bool includePersonalGold;

  /// قيمة العروض التجارية.
  final double tradeGoods;

  /// الديون المستحقة للمستخدم التي يُرجى تحصيلها.
  final double receivableDebts;

  /// الديون والالتزامات الحالّة التي يرى المستخدم جواز خصمها.
  final double liabilities;

  /// هل مر حول كامل (سنة هجرية) على المال وهو بالغ للنصاب؟
  final bool hawlCompleted;

  /// معيار النصاب (ذهب أو فضة).
  final NisabStandard standard;

  /// تاريخ إدخال/تحديث الأسعار.
  final DateTime priceDate;
}

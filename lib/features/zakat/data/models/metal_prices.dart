/// بيانات أسعار الذهب والفضة بالجنيه المصري لكل جرام.
class MetalPrices {
  const MetalPrices({
    required this.pureGoldPricePerGram,
    required this.silverPricePerGram,
    required this.fetchedAt,
  });

  /// سعر جرام الذهب الخالص (عيار 24) بالجنيه المصري.
  final double pureGoldPricePerGram;

  /// سعر جرام الفضة النقية بالجنيه المصري.
  final double silverPricePerGram;

  /// وقت جلب الأسعار.
  final DateTime fetchedAt;

  /// حساب سعر جرام الذهب لعيار معين (24، 21، 18، إلخ).
  double priceForKarat(int karat) {
    if (karat <= 0) return pureGoldPricePerGram;
    return pureGoldPricePerGram * karat / 24.0;
  }
}

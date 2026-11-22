import 'zakat_currency.dart';

/// بيانات أسعار الذهب والفضة لكل جرام بعملة الحساب المختارة.
class MetalPrices {
  const MetalPrices({
    required this.pureGoldPricePerGram,
    required this.silverPricePerGram,
    required this.fetchedAt,
    this.currency = ZakatCurrency.egyptianPound,
  });

  /// سعر جرام الذهب الخالص (عيار 24) بعملة الحساب.
  final double pureGoldPricePerGram;

  /// سعر جرام الفضة النقية بعملة الحساب.
  final double silverPricePerGram;

  /// العملة التي جُلبت بها الأسعار، وهي عملة الحساب نفسه.
  final ZakatCurrency currency;

  /// وقت جلب الأسعار.
  final DateTime fetchedAt;

  /// حساب سعر جرام الذهب لعيار معين (24، 21، 18، إلخ).
  double priceForKarat(int karat) {
    if (karat <= 0) return pureGoldPricePerGram;
    return pureGoldPricePerGram * karat / 24.0;
  }
}

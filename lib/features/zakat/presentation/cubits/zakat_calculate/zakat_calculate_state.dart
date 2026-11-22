import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';

class ZakatCalculateState {
  const ZakatCalculateState({
    this.currency = ZakatCurrency.egyptianPound,
    this.standard = NisabStandard.gold,
    this.goldKarat = 21,
    this.goldPersonal = false,
    this.includePersonalGold = false,
    this.hawlCompleted = false,
    this.hawlError = false,
    this.isLoadingPrices = false,
    this.pricesFetchedOnline = false,
    this.fetchedPrices,
    this.priceError = false,
  });

  /// عملة الحساب نفسها: كل المبالغ والأسعار والنصاب بهذه العملة.
  final ZakatCurrency currency;
  final NisabStandard standard;
  final int goldKarat;
  final bool goldPersonal;
  final bool includePersonalGold;
  final bool hawlCompleted;
  final bool hawlError;
  final bool isLoadingPrices;
  final bool pricesFetchedOnline;
  final MetalPrices? fetchedPrices;

  /// Set when a submitted calculation could not resolve a usable metal price.
  /// The UI keeps the user in the price step until this is cleared.
  final bool priceError;

  bool get hasLivePrices => pricesFetchedOnline && fetchedPrices != null;

  /// The price actually used by the calculation in live-price mode.
  double? get resolvedGoldPrice =>
      hasLivePrices ? fetchedPrices!.priceForKarat(goldKarat) : null;

  double? get resolvedSilverPrice =>
      hasLivePrices ? fetchedPrices!.silverPricePerGram : null;

  ZakatCalculateState copyWith({
    ZakatCurrency? currency,
    NisabStandard? standard,
    int? goldKarat,
    bool? goldPersonal,
    bool? includePersonalGold,
    bool? hawlCompleted,
    bool? hawlError,
    bool? isLoadingPrices,
    bool? pricesFetchedOnline,
    MetalPrices? fetchedPrices,
    bool clearFetchedPrices = false,
    bool? priceError,
  }) {
    return ZakatCalculateState(
      currency: currency ?? this.currency,
      standard: standard ?? this.standard,
      goldKarat: goldKarat ?? this.goldKarat,
      goldPersonal: goldPersonal ?? this.goldPersonal,
      includePersonalGold: includePersonalGold ?? this.includePersonalGold,
      hawlCompleted: hawlCompleted ?? this.hawlCompleted,
      hawlError: hawlError ?? this.hawlError,
      isLoadingPrices: isLoadingPrices ?? this.isLoadingPrices,
      pricesFetchedOnline: pricesFetchedOnline ?? this.pricesFetchedOnline,
      fetchedPrices: clearFetchedPrices
          ? null
          : (fetchedPrices ?? this.fetchedPrices),
      priceError: priceError ?? this.priceError,
    );
  }
}

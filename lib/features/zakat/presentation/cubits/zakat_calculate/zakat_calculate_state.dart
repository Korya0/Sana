import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';

class ZakatCalculateState {
  const ZakatCalculateState({
    this.standard = NisabStandard.gold,
    this.goldKarat = 21,
    this.goldPersonal = false,
    this.includePersonalGold = false,
    this.hawlCompleted = false,
    this.hawlError = false,
    this.isLoadingPrices = false,
    this.pricesFetchedOnline = false,
    this.fetchedPrices,
  });

  final NisabStandard standard;
  final int goldKarat;
  final bool goldPersonal;
  final bool includePersonalGold;
  final bool hawlCompleted;
  final bool hawlError;
  final bool isLoadingPrices;
  final bool pricesFetchedOnline;
  final MetalPrices? fetchedPrices;

  ZakatCalculateState copyWith({
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
  }) {
    return ZakatCalculateState(
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
    );
  }
}

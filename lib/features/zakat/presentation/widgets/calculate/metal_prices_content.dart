import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'live_metal_prices_card.dart';
import 'loading_prices_indicator.dart';
import 'manual_metal_price_fields.dart';

class MetalPricesContent extends StatelessWidget {
  const MetalPricesContent({
    super.key,
    required this.isLoadingPrices,
    required this.pricesFetchedOnline,
    required this.fetchedPrices,
    required this.goldKarat,
    required this.goldPriceController,
    required this.silverPriceController,
    required this.needsGoldPrice,
    required this.needsSilverPrice,
    required this.priceValidator,
    required this.onRefreshPrices,
    required this.onFetchOnlinePressed,
  });

  final bool isLoadingPrices;
  final bool pricesFetchedOnline;
  final MetalPrices? fetchedPrices;
  final int goldKarat;
  final TextEditingController goldPriceController;
  final TextEditingController silverPriceController;
  final bool needsGoldPrice;
  final bool needsSilverPrice;
  final String? Function(
    String?, {
    required bool required,
    required String metal,
  })
  priceValidator;
  final VoidCallback onRefreshPrices;
  final VoidCallback onFetchOnlinePressed;

  @override
  Widget build(BuildContext context) {
    if (isLoadingPrices) {
      return const LoadingPricesIndicator();
    }
    if (pricesFetchedOnline && fetchedPrices != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 14),
        child: LiveMetalPricesCard(
          prices: fetchedPrices!,
          goldKarat: goldKarat,
          onRefresh: onRefreshPrices,
        ),
      );
    }
    return ManualMetalPriceFields(
      goldPriceController: goldPriceController,
      silverPriceController: silverPriceController,
      goldKarat: goldKarat,
      needsGoldPrice: needsGoldPrice,
      needsSilverPrice: needsSilverPrice,
      priceValidator: priceValidator,
      isLoadingPrices: isLoadingPrices,
      onFetchOnlinePressed: onFetchOnlinePressed,
    );
  }
}

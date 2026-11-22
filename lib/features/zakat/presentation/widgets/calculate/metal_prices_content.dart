import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import '../zakat_note_box.dart';
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
    required this.currency,
    required this.goldPriceController,
    required this.silverPriceController,
    required this.needsGoldPrice,
    required this.needsSilverPrice,
    required this.priceValidator,
    required this.onRefreshPrices,
    required this.onFetchOnlinePressed,
    required this.onPriceFieldChanged,
    this.priceError = false,
  });

  final bool isLoadingPrices;
  final bool pricesFetchedOnline;
  final MetalPrices? fetchedPrices;
  final int goldKarat;
  final ZakatCurrency currency;
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
  final ValueChanged<String> onPriceFieldChanged;
  final bool priceError;

  @override
  Widget build(BuildContext context) {
    final Widget priceContent;
    if (isLoadingPrices) {
      priceContent = const LoadingPricesIndicator();
    } else if (pricesFetchedOnline && fetchedPrices != null) {
      priceContent = LiveMetalPricesCard(
        prices: fetchedPrices!,
        goldKarat: goldKarat,
        onRefresh: onRefreshPrices,
      );
    } else {
      priceContent = ManualMetalPriceFields(
        goldPriceController: goldPriceController,
        silverPriceController: silverPriceController,
        goldKarat: goldKarat,
        currency: currency,
        needsGoldPrice: needsGoldPrice,
        needsSilverPrice: needsSilverPrice,
        priceValidator: priceValidator,
        isLoadingPrices: isLoadingPrices,
        onFetchOnlinePressed: onFetchOnlinePressed,
        onPriceChanged: onPriceFieldChanged,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        priceContent,
        if (priceError && !isLoadingPrices) ...[
          AppGap.h(AppSize.p12),
          Semantics(
            liveRegion: true,
            child: const ZakatNoteBox(
              AppStrings.zakatPriceErrorInline,
              icon: AppIcons.warning,
            ),
          ),
        ],
      ],
    );
  }
}

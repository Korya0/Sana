import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import '../zakat_info_card.dart';
import '../zakat_note_box.dart';
import 'metal_prices_content.dart';
import 'nisab_preview_text.dart';
import 'nisab_standard_selector.dart';

class NisabAndPricesSection extends StatelessWidget {
  const NisabAndPricesSection({
    super.key,
    required this.standard,
    required this.onStandardChanged,
    required this.goldKarat,
    required this.onKaratChanged,
    required this.currency,
    required this.goldPrice,
    required this.silverPrice,
    required this.goldPriceController,
    required this.silverPriceController,
    required this.isLoadingPrices,
    required this.pricesFetchedOnline,
    required this.fetchedPrices,
    required this.onRefreshPrices,
    required this.onFetchOnlinePressed,
    required this.priceValidator,
    required this.needsGoldPrice,
    required this.needsSilverPrice,
    required this.onPriceFieldChanged,
    this.priceError = false,
  });

  final NisabStandard standard;
  final ValueChanged<NisabStandard> onStandardChanged;
  final int goldKarat;
  final ValueChanged<int?> onKaratChanged;
  final ZakatCurrency currency;

  /// الأسعار المعتمدة فعليًا في الحساب؛ تُمرَّر من الـ cubit حتى تكون معاينة
  /// النصاب مطابقة للسعر الجالب بالعملة المختارة وللنتيجة النهائية.
  final double? goldPrice;
  final double? silverPrice;

  final TextEditingController goldPriceController;
  final TextEditingController silverPriceController;
  final bool isLoadingPrices;
  final bool pricesFetchedOnline;
  final MetalPrices? fetchedPrices;
  final VoidCallback onRefreshPrices;
  final VoidCallback onFetchOnlinePressed;
  final String? Function(
    String?, {
    required bool required,
    required String metal,
  })
  priceValidator;
  final bool needsGoldPrice;
  final bool needsSilverPrice;
  final ValueChanged<String> onPriceFieldChanged;
  final bool priceError;

  @override
  Widget build(BuildContext context) {
    return ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NisabStandardSelector(
            standard: standard,
            onStandardChanged: onStandardChanged,
            goldKarat: goldKarat,
            onKaratChanged: onKaratChanged,
          ),
          MetalPricesContent(
            isLoadingPrices: isLoadingPrices,
            pricesFetchedOnline: pricesFetchedOnline,
            fetchedPrices: fetchedPrices,
            goldKarat: goldKarat,
            currency: currency,
            goldPriceController: goldPriceController,
            silverPriceController: silverPriceController,
            needsGoldPrice: needsGoldPrice,
            needsSilverPrice: needsSilverPrice,
            priceValidator: priceValidator,
            onRefreshPrices: onRefreshPrices,
            onFetchOnlinePressed: onFetchOnlinePressed,
            onPriceFieldChanged: onPriceFieldChanged,
            priceError: priceError,
          ),
          AppGap.h(AppSize.p12),
          ListenableBuilder(
            listenable: Listenable.merge([
              goldPriceController,
              silverPriceController,
            ]),
            builder: (context, _) => NisabPreviewText(
              standard: standard,
              goldPrice: goldPrice,
              goldKarat: goldKarat,
              silverPrice: silverPrice,
              currency: currency,
            ),
          ),
          AppGap.h(AppSize.p12),
          ZakatNoteBox(
            pricesFetchedOnline
                ? AppStrings.zakatPricesOnlineNote
                : AppStrings.zakatPricesOfflineNote,
          ),
        ],
      ),
    );
  }
}

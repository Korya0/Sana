import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
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
  });

  final NisabStandard standard;
  final ValueChanged<NisabStandard> onStandardChanged;
  final int goldKarat;
  final ValueChanged<int?> onKaratChanged;
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
            goldPriceController: goldPriceController,
            silverPriceController: silverPriceController,
            needsGoldPrice: needsGoldPrice,
            needsSilverPrice: needsSilverPrice,
            priceValidator: priceValidator,
            onRefreshPrices: onRefreshPrices,
            onFetchOnlinePressed: onFetchOnlinePressed,
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: Listenable.merge([
              goldPriceController,
              silverPriceController,
            ]),
            builder: (context, _) => NisabPreviewText(
              standard: standard,
              goldPrice: NumberUtils.parseAmount(goldPriceController.text),
              goldKarat: goldKarat,
              silverPrice: NumberUtils.parseAmount(silverPriceController.text),
            ),
          ),
          const SizedBox(height: 10),
          ZakatNoteBox(
            pricesFetchedOnline
                ? 'تم جلب أسعار الذهب والفضة آليًا عبر الإنترنت وفقًا لأسعار السوق الحالية.'
                : 'يختلف النصاب بحسب المعيار. يمكنك إدخال الأسعار يدويًا لعدم توفر اتصال بالإنترنت.',
          ),
        ],
      ),
    );
  }
}

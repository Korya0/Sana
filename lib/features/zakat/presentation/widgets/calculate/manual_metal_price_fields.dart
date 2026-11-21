import 'package:flutter/material.dart';
import '../zakat_money_field.dart';

class ManualMetalPriceFields extends StatelessWidget {
  const ManualMetalPriceFields({
    super.key,
    required this.goldPriceController,
    required this.silverPriceController,
    required this.goldKarat,
    required this.needsGoldPrice,
    required this.needsSilverPrice,
    required this.priceValidator,
    required this.isLoadingPrices,
    required this.onFetchOnlinePressed,
  });

  final TextEditingController goldPriceController;
  final TextEditingController silverPriceController;
  final int goldKarat;
  final bool needsGoldPrice;
  final bool needsSilverPrice;
  final String? Function(
    String?, {
    required bool required,
    required String metal,
  })
  priceValidator;
  final bool isLoadingPrices;
  final VoidCallback onFetchOnlinePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 14),
        ZakatMoneyField(
          controller: goldPriceController,
          label: 'سعر جرام الذهب عيار $goldKarat',
          helper: 'أدخل سعر الجرام من العيار المختار.',
          suffix: 'جنيه / جرام',
          extraValidator: (v) =>
              priceValidator(v, required: needsGoldPrice, metal: 'الذهب'),
        ),
        const SizedBox(height: 14),
        ZakatMoneyField(
          controller: silverPriceController,
          label: 'سعر جرام الفضة النقية',
          helper: 'أدخل سعر الجرام الحالي من مصدر موثوق.',
          suffix: 'جنيه / جرام',
          extraValidator: (v) =>
              priceValidator(v, required: needsSilverPrice, metal: 'الفضة'),
        ),
        if (!isLoadingPrices) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: onFetchOnlinePressed,
              icon: const Icon(Icons.wifi, size: 18),
              label: const Text('جلب أسعار الذهب والفضة تلقائيًا عبر الإنترنت'),
            ),
          ),
        ],
      ],
    );
  }
}

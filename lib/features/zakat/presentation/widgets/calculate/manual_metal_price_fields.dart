import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import '../zakat_money_field.dart';

class ManualMetalPriceFields extends StatelessWidget {
  const ManualMetalPriceFields({
    super.key,
    required this.goldPriceController,
    required this.silverPriceController,
    required this.goldKarat,
    required this.currency,
    required this.needsGoldPrice,
    required this.needsSilverPrice,
    required this.priceValidator,
    required this.isLoadingPrices,
    required this.onFetchOnlinePressed,
    this.onPriceChanged,
  });

  final TextEditingController goldPriceController;
  final TextEditingController silverPriceController;
  final int goldKarat;
  final ZakatCurrency currency;
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
  final ValueChanged<String>? onPriceChanged;

  @override
  Widget build(BuildContext context) {
    final priceSuffix = AppStrings.zakatPriceSuffixFor(currency.suffix);

    return Column(
      children: [
        AppGap.h(AppSize.p16),
        ZakatMoneyField(
          controller: goldPriceController,
          label: AppStrings.zakatGoldPriceLabel(goldKarat),
          helper: AppStrings.zakatGoldPriceHelper,
          suffix: priceSuffix,
          onChanged: onPriceChanged,
          extraValidator: (v) => priceValidator(
            v,
            required: needsGoldPrice,
            metal: AppStrings.zakatMetalGold,
          ),
        ),
        AppGap.h(AppSize.p16),
        ZakatMoneyField(
          controller: silverPriceController,
          label: AppStrings.zakatSilverPriceLabel,
          helper: AppStrings.zakatSilverPriceHelper,
          suffix: priceSuffix,
          onChanged: onPriceChanged,
          extraValidator: (v) => priceValidator(
            v,
            required: needsSilverPrice,
            metal: AppStrings.zakatMetalSilver,
          ),
        ),
        if (!isLoadingPrices) ...[
          AppGap.h(AppSize.p8),
          Center(
            child: TextButton.icon(
              onPressed: onFetchOnlinePressed,
              icon: Icon(
                AppIcons.wifi,
                size: AppSize.icon16,
              ),
              label: const Text(AppStrings.zakatFetchPrices),
            ),
          ),
        ],
      ],
    );
  }
}

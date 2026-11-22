import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/services/zakat_calculator.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

class NisabPreviewText extends StatelessWidget {
  const NisabPreviewText({
    super.key,
    required this.standard,
    required this.goldPrice,
    required this.goldKarat,
    required this.silverPrice,
    required this.currency,
  });

  final NisabStandard standard;
  final double? goldPrice;
  final int goldKarat;
  final double? silverPrice;
  final ZakatCurrency currency;

  @override
  Widget build(BuildContext context) {
    final nisab = ZakatCalculator.nisabValue(
      standard: standard,
      goldPricePerGram: goldPrice,
      goldKarat: goldKarat,
      silverPricePerGram: silverPrice,
    );

    late final String text;
    if (nisab == null) {
      text = standard == NisabStandard.gold
          ? AppStrings.zakatNisabPreviewMissingGold
          : AppStrings.zakatNisabPreviewMissingSilver;
    } else if (standard == NisabStandard.gold) {
      final purePrice = ZakatCalculator.pureGoldPrice(goldPrice, goldKarat);
      final pureText = purePrice == null
          ? AppStrings.zakatUnknown
          : NumberUtils.formatMoney(purePrice, currency: currency);
      text =
          '${AppStrings.zakatNisabPreviewPrefix}'
          '${NumberUtils.formatAmount(ZakatCalculator.goldNisabGrams)} '
          '${AppStrings.zakatGramsSuffix} × '
          '${AppStrings.zakatNisabPreviewPure} ($pureText) = '
          '${NumberUtils.formatMoney(nisab, currency: currency)}';
    } else {
      final price = silverPrice;
      final silverText = price == null
          ? AppStrings.zakatUnknown
          : NumberUtils.formatMoney(price, currency: currency);
      text =
          '${AppStrings.zakatNisabPreviewPrefix}'
          '${NumberUtils.formatAmount(ZakatCalculator.silverNisabGrams)} '
          '${AppStrings.zakatGramsSuffix} × '
          '${AppStrings.zakatNisabPreviewSilverPrice} ($silverText) = '
          '${NumberUtils.formatMoney(nisab, currency: currency)}';
    }

    return Semantics(
      liveRegion: true,
      child: Text(
        text,
        style: AppTextStyles.font14W400Relaxed(
          context,
          context.color.textSecondary,
        ),
      ),
    );
  }
}

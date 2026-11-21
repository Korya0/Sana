import 'package:flutter/material.dart';
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
  });

  final NisabStandard standard;
  final double? goldPrice;
  final int goldKarat;
  final double? silverPrice;

  @override
  Widget build(BuildContext context) {
    final nisab = ZakatCalculator.nisabValue(
      standard: standard,
      goldPricePerGram: goldPrice,
      goldKarat: goldKarat,
      silverPricePerGram: silverPrice,
    );

    String text;
    if (nisab == null) {
      text = standard == NisabStandard.gold
          ? 'أدخل سعر جرام الذهب لتظهر قيمة النصاب التقديرية.'
          : 'أدخل سعر جرام الفضة لتظهر قيمة النصاب التقديرية.';
    } else if (standard == NisabStandard.gold) {
      final purePrice = ZakatCalculator.pureGoldPrice(goldPrice, goldKarat)!;
      text =
          'النصاب التقديري = '
          '${NumberUtils.formatAmount(ZakatCalculator.goldNisabGrams)} جرامًا × '
          'سعر الخالص (${NumberUtils.formatAmount(purePrice)}) = '
          '${NumberUtils.formatMoney(nisab)}';
    } else {
      text =
          'النصاب التقديري = '
          '${NumberUtils.formatAmount(ZakatCalculator.silverNisabGrams)} جرامًا × '
          'السعر = ${NumberUtils.formatMoney(nisab)}';
    }

    return Text(text, style: const TextStyle(fontSize: 14.5, height: 1.6));
  }
}

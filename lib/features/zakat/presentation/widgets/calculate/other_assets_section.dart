import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_money_field.dart';

class OtherAssetsSection extends StatelessWidget {
  const OtherAssetsSection({
    super.key,
    required this.cashController,
    required this.silverGramsController,
    required this.silverPriceController,
    required this.tradeController,
    required this.receivableController,
    required this.currency,
  });

  final TextEditingController cashController;
  final TextEditingController silverGramsController;
  final TextEditingController silverPriceController;
  final TextEditingController tradeController;
  final TextEditingController receivableController;
  final ZakatCurrency currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZakatMoneyField(
          controller: cashController,
          label: AppStrings.zakatCashLabel,
          helper: AppStrings.zakatCashHelper,
          suffix: currency.suffix,
        ),
        AppGap.h(AppSize.p16),
        ZakatMoneyField(
          controller: silverGramsController,
          label: AppStrings.zakatSilverGramsLabel,
          helper: AppStrings.zakatSilverGramsHelper,
          suffix: AppStrings.zakatGramsSuffix,
        ),
        ListenableBuilder(
          listenable: Listenable.merge([
            silverGramsController,
            silverPriceController,
          ]),
          builder: (context, _) {
            final weight =
                NumberUtils.parseAmount(silverGramsController.text) ?? 0;
            final price =
                NumberUtils.parseAmount(silverPriceController.text) ?? 0;
            if (weight <= 0 || price <= 0) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: AppSize.p8),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  AppStrings.zakatMetalValue(
                    metal: AppStrings.zakatMetalSilver,
                    weight: NumberUtils.formatAmount(weight),
                    price: NumberUtils.formatAmount(price),
                    value: NumberUtils.formatMoney(
                      weight * price,
                      currency: currency,
                    ),
                  ),
                  style: AppTextStyles.font14W400Relaxed(context),
                ),
              ),
            );
          },
        ),
        AppGap.h(AppSize.p16),
        ZakatMoneyField(
          controller: tradeController,
          label: AppStrings.zakatTradeLabel,
          helper: AppStrings.zakatTradeHelper,
          suffix: currency.suffix,
        ),
        AppGap.h(AppSize.p16),
        ZakatMoneyField(
          controller: receivableController,
          label: AppStrings.zakatReceivableLabel,
          helper: AppStrings.zakatReceivableHelper,
          suffix: currency.suffix,
        ),
      ],
    );
  }
}

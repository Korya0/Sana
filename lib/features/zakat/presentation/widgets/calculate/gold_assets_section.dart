import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_money_field.dart';

class GoldAssetsSection extends StatelessWidget {
  const GoldAssetsSection({
    super.key,
    required this.goldGramsController,
    required this.goldPriceController,
    required this.goldKarat,
    required this.goldPersonal,
    required this.onGoldPersonalChanged,
    required this.includePersonalGold,
    required this.onIncludePersonalGoldChanged,
    required this.currency,
  });

  final TextEditingController goldGramsController;
  final TextEditingController goldPriceController;
  final int goldKarat;
  final bool goldPersonal;
  final ValueChanged<bool> onGoldPersonalChanged;
  final bool includePersonalGold;
  final ValueChanged<bool> onIncludePersonalGoldChanged;
  final ZakatCurrency currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZakatMoneyField(
          controller: goldGramsController,
          label: AppStrings.zakatGoldGramsLabelFor(goldKarat),
          helper: AppStrings.zakatGoldGramsHelper,
          suffix: AppStrings.zakatGramsSuffix,
        ),
        ListenableBuilder(
          listenable: Listenable.merge([
            goldGramsController,
            goldPriceController,
          ]),
          builder: (context, _) {
            final weight =
                NumberUtils.parseAmount(goldGramsController.text) ?? 0;
            final price =
                NumberUtils.parseAmount(goldPriceController.text) ?? 0;
            if (weight <= 0 || price <= 0) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: AppSize.p8),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  AppStrings.zakatMetalValue(
                    metal: AppStrings.zakatMetalGold,
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
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            AppStrings.zakatGoldPersonalLabel,
            style: AppTextStyles.font16W700Primary(context),
          ),
          subtitle: Text(
            AppStrings.zakatGoldPersonalSubtitle,
            style: AppTextStyles.font14W400Relaxed(context),
          ),
          value: goldPersonal,
          onChanged: onGoldPersonalChanged,
        ),
        if (goldPersonal)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              AppStrings.zakatIncludePersonalGoldLabel,
              style: AppTextStyles.font16W700Primary(context),
            ),
            subtitle: Text(
              AppStrings.zakatIncludePersonalGoldSubtitle,
              style: AppTextStyles.font14W400Relaxed(context),
            ),
            value: includePersonalGold,
            onChanged: onIncludePersonalGoldChanged,
          ),
      ],
    );
  }
}

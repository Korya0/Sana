import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_info_card.dart';
import '../zakat_result_row.dart';

class AssetsBreakdownCard extends StatelessWidget {
  const AssetsBreakdownCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    final input = result.input;
    final currency = result.currency;
    final nisabText = result.nisabValue == null
        ? AppStrings.zakatUnknown
        : NumberUtils.formatMoney(result.nisabValue!, currency: currency);

    return ZakatInfoCard(
      child: Column(
        children: [
          ZakatResultRow(
            label: AppStrings.zakatTotalAssets,
            value: NumberUtils.formatMoney(
              result.totalAssets,
              currency: currency,
            ),
          ),
          ZakatResultRow(
            label: AppStrings.zakatDeductions,
            value: result.appliedDeductions > 0
                ? '- ${NumberUtils.formatMoney(result.appliedDeductions, currency: currency)}'
                : NumberUtils.formatMoney(0, currency: currency),
          ),
          Divider(color: context.color.dividerColor),
          ZakatResultRow(
            label: result.status == ZakatStatus.nisabUnknown
                ? AppStrings.zakatNetEstimated
                : AppStrings.zakatNet,
            value: NumberUtils.formatMoney(
              result.netAmount,
              currency: currency,
            ),
            bold: true,
          ),
          Divider(color: context.color.dividerColor),
          _subHeader(context, AppStrings.zakatMetals),
          ZakatResultRow(
            label: AppStrings.zakatGoldValue,
            value: NumberUtils.formatMoney(
              result.goldValue,
              currency: currency,
            ),
          ),
          if (input.goldGrams > 0)
            ZakatResultRow(
              label: AppStrings.zakatGoldWeight,
              value: AppStrings.zakatGoldWeightValue(
                NumberUtils.formatAmount(input.goldGrams),
                input.goldKarat,
              ),
            ),
          ZakatResultRow(
            label: AppStrings.zakatSilverValue,
            value: NumberUtils.formatMoney(
              result.silverValue,
              currency: currency,
            ),
          ),
          if (input.silverGrams > 0)
            ZakatResultRow(
              label: AppStrings.zakatSilverWeight,
              value: AppStrings.zakatSilverWeightValue(
                NumberUtils.formatAmount(input.silverGrams),
              ),
            ),
          Divider(color: context.color.dividerColor),
          _subHeader(context, AppStrings.zakatNisabSection),
          ZakatResultRow(
            label: AppStrings.zakatStandardUsed,
            value: AppStrings.zakatNisabStandardLabel(input.standard.label),
          ),
          ZakatResultRow(
            label: AppStrings.zakatSummaryNisabIn(currency.label),
            value: nisabText,
          ),
          ZakatResultRow(
            label: AppStrings.zakatCurrencyTitle,
            value: currency.menuLabel,
          ),
          ZakatResultRow(
            label: AppStrings.zakatHawlCompleted,
            value: input.hawlCompleted
                ? AppStrings.zakatYes
                : AppStrings.zakatNo,
          ),
        ],
      ),
    );
  }

  Widget _subHeader(BuildContext context, String text) => Padding(
    padding: EdgeInsets.only(top: AppSize.p8, bottom: AppSize.p4),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: Semantics(
        header: true,
        child: Text(text, style: AppTextStyles.font14W700Brand(context)),
      ),
    ),
  );
}

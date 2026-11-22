import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

class LiveMetalPricesCard extends StatelessWidget {
  const LiveMetalPricesCard({
    super.key,
    required this.prices,
    required this.goldKarat,
    required this.onRefresh,
  });

  final MetalPrices prices;
  final int goldKarat;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final goldPrice = NumberUtils.formatAmount(prices.priceForKarat(goldKarat));
    final silverPrice = NumberUtils.formatAmount(prices.silverPricePerGram);
    final suffix = prices.currency.suffix;

    return Semantics(
      container: true,
      label: AppStrings.zakatPricesSemanticsLabel,
      explicitChildNodes: true,
      child: Container(
        padding: EdgeInsets.all(AppSize.p12),
        decoration: BoxDecoration(
          color: context.color.surfaceBrand.withValues(
            alpha: AppConstants.opacityGhost,
          ),
          borderRadius: BorderRadius.circular(AppSize.r12),
          border: Border.all(
            color: context.color.borderBrand.withValues(
              alpha: AppConstants.opacityMuted,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(
                    AppIcons.wifi,
                    color: context.color.iconBrand,
                    size: AppSize.icon16,
                  ),
                ),
                AppGap.w(AppSize.p8),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      AppStrings.zakatLivePricesTitle,
                      style: AppTextStyles.font14W700Brand(context),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    AppIcons.refresh,
                    size: AppSize.icon16,
                    color: context.color.iconBrand,
                  ),
                  tooltip: AppStrings.zakatRefreshPrices,
                  onPressed: onRefresh,
                ),
              ],
            ),
            Divider(
              height: AppSize.p16,
              color: context.color.dividerColor,
            ),
            _PriceRow(
              label: AppStrings.zakatGoldLivePriceLabel(goldKarat),
              value: '$suffix $goldPrice',
              semanticsLabel: AppStrings.zakatGoldLivePriceLabel(goldKarat),
              semanticsValue: '$goldPrice $suffix',
            ),
            AppGap.h(AppSize.p8),
            _PriceRow(
              label: AppStrings.zakatSilverLivePriceLabel,
              value: '$suffix $silverPrice',
              semanticsLabel: AppStrings.zakatSilverLivePriceLabel,
              semanticsValue: '$silverPrice $suffix',
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    required this.semanticsLabel,
    required this.semanticsValue,
  });

  final String label;
  final String value;
  final String semanticsLabel;
  final String semanticsValue;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticsLabel,
      value: semanticsValue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                label,
                style: AppTextStyles.font14W400Primary(context),
              ),
            ),
          ),
          AppGap.w(AppSize.p8),
          Flexible(
            child: ExcludeSemantics(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.font14W700Brand(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

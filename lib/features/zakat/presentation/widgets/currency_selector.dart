import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'zakat_field_border.dart';

/// أول اختيار في خطوة النصاب والأسعار: عملة الحساب التي تُحسب بها كل القيم.
class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    super.key,
    required this.currency,
    required this.onChanged,
  });

  final ZakatCurrency currency;
  final ValueChanged<ZakatCurrency> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: AppStrings.zakatCurrencySemantics(currency.label),
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Row(
              children: [
                Icon(
                  AppIcons.currency,
                  size: AppSize.icon16,
                  color: context.color.iconBrand,
                ),
                AppGap.w(AppSize.p8),
                Text(
                  AppStrings.zakatCurrencyTitle,
                  style: AppTextStyles.font14W700Brand(context),
                ),
              ],
            ),
          ),
          AppGap.h(AppSize.p4),
          Text(
            AppStrings.zakatCurrencyHelper,
            style: AppTextStyles.font14W400Relaxed(
              context,
              context.color.textSecondary,
            ),
          ),
          AppGap.h(AppSize.p12),
          DropdownButtonFormField<ZakatCurrency>(
            initialValue: currency,
            isExpanded: true,
            icon: Icon(
              AppIcons.dropdown,
              size: AppSize.icon16,
              color: context.color.iconSecondary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: context.color.scaffoldBackgroundColor,
              labelText: AppStrings.zakatCurrencyLabel,
              labelStyle: AppTextStyles.font14W500Secondary(context),
              floatingLabelStyle: AppTextStyles.font12W700Brand(context),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSize.p16,
                vertical: AppSize.p12,
              ),
              border: zakatFieldBorder(context),
              enabledBorder: zakatFieldBorder(context),
              focusedBorder: zakatFieldBorder(
                context,
                color: context.color.borderBrand,
              ),
            ),
            items: [
              for (final option in ZakatCurrency.values)
                DropdownMenuItem<ZakatCurrency>(
                  value: option,
                  child: Text(
                    option.menuLabel,
                    style: AppTextStyles.font14W400Primary(context),
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

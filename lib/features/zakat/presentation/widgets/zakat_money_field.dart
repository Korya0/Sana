import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import 'zakat_field_border.dart';

class ZakatMoneyField extends StatelessWidget {
  const ZakatMoneyField({
    super.key,
    required this.controller,
    required this.label,
    required this.helper,
    this.suffix = AppStrings.zakatPoundSuffix,
    this.textInputAction = TextInputAction.next,
    this.extraValidator,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String helper;
  final String suffix;
  final TextInputAction textInputAction;
  final String? Function(String?)? extraValidator;
  final ValueChanged<String>? onChanged;

  String? _message(String? value) {
    final parsed = NumberUtils.parseAmount(value);
    if (parsed == null) return AppStrings.zakatInvalidNumber;
    if (parsed > 1e12) return AppStrings.zakatValueTooLarge;
    return extraValidator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final message = _message(controller.text);

    return Semantics(
      container: true,
      label: label,
      hint: helper,
      value: controller.text.trim().isEmpty
          ? AppStrings.zakatEmptyField
          : controller.text,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: textInputAction,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9٠-٩۰-۹.,٫٬]'),
              ),
            ],
            style: AppTextStyles.font18W500Primary(context),
            cursorColor: context.color.textBrand,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: context.color.scaffoldBackgroundColor,
              labelText: label,
              labelStyle: AppTextStyles.font14W500Secondary(context),
              floatingLabelStyle: AppTextStyles.font12W700Brand(context),
              helperText: helper,
              helperMaxLines: 2,
              helperStyle: AppTextStyles.font12W500Secondary(context),
              suffixText: suffix,
              suffixStyle: AppTextStyles.font14W500Secondary(context),
              errorStyle: AppTextStyles.font12W500Error(context),
              errorMaxLines: 2,
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
              errorBorder: zakatFieldBorder(
                context,
                color: context.color.errorText,
              ),
              focusedErrorBorder: zakatFieldBorder(
                context,
                color: context.color.errorText,
              ),
              disabledBorder: zakatFieldBorder(context),
            ),
            validator: _message,
          ),
          Semantics(
            liveRegion: true,
            label: message ?? '',
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

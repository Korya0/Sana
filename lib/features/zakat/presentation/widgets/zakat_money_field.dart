import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

class ZakatMoneyField extends StatelessWidget {
  const ZakatMoneyField({
    super.key,
    required this.controller,
    required this.label,
    required this.helper,
    this.suffix = 'جنيه',
    this.textInputAction = TextInputAction.next,
    this.extraValidator,
  });

  final TextEditingController controller;
  final String label;
  final String helper;
  final String suffix;
  final TextInputAction textInputAction;
  final String? Function(String?)? extraValidator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩۰-۹.,٫٬]')),
      ],
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        suffixText: suffix,
      ),
      validator: (value) {
        final parsed = NumberUtils.parseAmount(value);
        if (parsed == null) return 'أدخل رقمًا صحيحًا (بدون علامة سالبة).';
        if (parsed > 1e12) return 'القيمة كبيرة جدًا، تأكد من الرقم.';
        return extraValidator?.call(value);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import '../zakat_money_field.dart';

class DebtsSection extends StatelessWidget {
  const DebtsSection({
    super.key,
    required this.controller,
    required this.currency,
  });

  final TextEditingController controller;
  final ZakatCurrency currency;

  @override
  Widget build(BuildContext context) {
    return ZakatMoneyField(
      controller: controller,
      label: AppStrings.zakatDebtsLabel,
      helper: AppStrings.zakatDebtsHelper,
      suffix: currency.suffix,
      textInputAction: TextInputAction.done,
    );
  }
}

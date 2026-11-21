import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

class CalculateFormControllers {
  final goldPrice = TextEditingController();
  final silverPrice = TextEditingController();
  final cash = TextEditingController();
  final goldGrams = TextEditingController();
  final silverGrams = TextEditingController();
  final trade = TextEditingController();
  final receivable = TextEditingController();
  final liabilities = TextEditingController();

  List<TextEditingController> get all => [
    goldPrice,
    silverPrice,
    cash,
    goldGrams,
    silverGrams,
    trade,
    receivable,
    liabilities,
  ];

  void dispose() {
    for (final c in all) {
      c.dispose();
    }
  }

  void clear() {
    for (final c in all) {
      c.clear();
    }
  }

  double read(TextEditingController c) => NumberUtils.parseAmount(c.text) ?? 0;

  double? get goldPriceValue {
    final v = NumberUtils.parseAmount(goldPrice.text);
    return v != null && v > 0 ? v : null;
  }

  double? get silverPriceValue {
    final v = NumberUtils.parseAmount(silverPrice.text);
    return v != null && v > 0 ? v : null;
  }

  ZakatInput buildInput({
    required int goldKarat,
    required bool goldPersonal,
    required bool includePersonalGold,
    required bool hawlCompleted,
    required NisabStandard standard,
  }) {
    return ZakatInput(
      cash: read(cash),
      goldGrams: read(goldGrams),
      goldKarat: goldKarat,
      goldPricePerGram: goldPriceValue,
      silverGrams: read(silverGrams),
      silverPricePerGram: silverPriceValue,
      goldIsPersonalUse: goldPersonal,
      includePersonalGold: includePersonalGold,
      tradeGoods: read(trade),
      receivableDebts: read(receivable),
      liabilities: read(liabilities),
      hawlCompleted: hawlCompleted,
      standard: standard,
      priceDate: DateTime.now(),
    );
  }
}

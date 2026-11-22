import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
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

  bool get hasAnyAsset => [
    cash,
    goldGrams,
    silverGrams,
    trade,
    receivable,
  ].any((controller) => read(controller) > 0);

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

  /// Captures every field so a Clear action can be undone.
  List<String> snapshot() => all.map((c) => c.text).toList(growable: false);

  void restore(List<String> values) {
    for (var i = 0; i < all.length && i < values.length; i++) {
      all[i].text = values[i];
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

  /// [resolvedGoldPrice] and [resolvedSilverPrice] come from the cubit's live
  /// price state and take precedence over controller text. This keeps the
  /// result consistent with the price card the user can actually see.
  ZakatInput buildInput({
    required ZakatCurrency currency,
    required int goldKarat,
    required bool goldPersonal,
    required bool includePersonalGold,
    required bool hawlCompleted,
    required NisabStandard standard,
    double? resolvedGoldPrice,
    double? resolvedSilverPrice,
  }) {
    return ZakatInput(
      currency: currency,
      cash: read(cash),
      goldGrams: read(goldGrams),
      goldKarat: goldKarat,
      goldPricePerGram: resolvedGoldPrice ?? goldPriceValue,
      silverGrams: read(silverGrams),
      silverPricePerGram: resolvedSilverPrice ?? silverPriceValue,
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

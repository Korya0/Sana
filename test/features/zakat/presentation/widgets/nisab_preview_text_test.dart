import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';
import 'package:sana/features/zakat/presentation/widgets/calculate/nisab_preview_text.dart';

void main() {
  group('NisabPreviewText', () {
    testWidgets(
      'shows the gold nisab equation priced in the selected currency',
      (tester) async {
        await _pump(
          tester,
          standard: NisabStandard.gold,
          goldPrice: 5000,
          currency: ZakatCurrency.saudiRiyal,
        );

        expect(
          _text(tester),
          'النصاب التقديري = 85 جرام × سعر الخالص (5,000 ريال) = 425,000 ريال',
        );
      },
    );

    testWidgets('shows the silver price too, in the selected currency', (
      tester,
    ) async {
      await _pump(
        tester,
        standard: NisabStandard.silver,
        silverPrice: 20,
        currency: ZakatCurrency.usDollar,
      );

      expect(
        _text(tester),
        'النصاب التقديري = 595 جرام × سعر الجرام (20 دولار) = 11,900 دولار',
      );
    });

    testWidgets('the equation follows the selected currency', (tester) async {
      await _pump(
        tester,
        standard: NisabStandard.gold,
        goldPrice: 5000,
        currency: ZakatCurrency.saudiRiyal,
      );
      expect(_text(tester), contains('425,000 ريال'));

      await _pump(
        tester,
        standard: NisabStandard.gold,
        goldPrice: 5000,
        currency: ZakatCurrency.euro,
      );
      expect(_text(tester), contains('425,000 يورو'));
    });
  });
}

String _text(WidgetTester tester) =>
    tester.widget<Text>(find.byType(Text)).data!;

Future<void> _pump(
  WidgetTester tester, {
  required NisabStandard standard,
  double? goldPrice,
  double? silverPrice,
  required ZakatCurrency currency,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: Scaffold(
        body: NisabPreviewText(
          standard: standard,
          goldPrice: goldPrice,
          goldKarat: 24,
          silverPrice: silverPrice,
          currency: currency,
        ),
      ),
    ),
  );
}

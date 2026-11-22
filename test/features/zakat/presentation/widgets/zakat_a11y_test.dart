import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/zakat/data/models/metal_prices.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/presentation/widgets/calculate/live_metal_prices_card.dart';
import 'package:sana/features/zakat/presentation/widgets/zakat_money_field.dart';
import 'package:sana/features/zakat/presentation/widgets/zakat_section_title.dart';

void main() {
  group('Zakat accessibility semantics', () {
    testWidgets('live price card exposes a named container and separate rows', (
      tester,
    ) async {
      await _pump(
        tester,
        LiveMetalPricesCard(
          prices: MetalPrices(
            pureGoldPricePerGram: 6000,
            silverPricePerGram: 50,
            fetchedAt: DateTime(2026),
          ),
          goldKarat: 21,
          onRefresh: () {},
        ),
      );

      expect(
        _semanticsWithLabel(tester, AppStrings.zakatPricesSemanticsLabel),
        1,
      );
      expect(
        _semanticsMatching(
          tester,
          (p) => p.value == '5,250 جنيه',
        ),
        1,
      );
      expect(
        _semanticsMatching(
          tester,
          (p) => p.value == '50 جنيه',
        ),
        1,
      );
    });

    testWidgets('live price card names the selected calculation currency', (
      tester,
    ) async {
      await _pump(
        tester,
        LiveMetalPricesCard(
          prices: MetalPrices(
            pureGoldPricePerGram: 700,
            silverPricePerGram: 6,
            fetchedAt: DateTime(2026),
            currency: ZakatCurrency.saudiRiyal,
          ),
          goldKarat: 21,
          onRefresh: () {},
        ),
      );

      expect(
        _semanticsMatching(
          tester,
          (p) => p.value == '612.50 ريال',
        ),
        1,
      );
      expect(
        _semanticsMatching(
          tester,
          (p) => p.value == '6 ريال',
        ),
        1,
      );
    });

    testWidgets('money field exposes its label, value and helper', (
      tester,
    ) async {
      final controller = TextEditingController(text: '1200');
      addTearDown(controller.dispose);

      await _pump(
        tester,
        ZakatMoneyField(
          controller: controller,
          label: AppStrings.zakatCashLabel,
          helper: AppStrings.zakatCashHelper,
        ),
      );

      final properties = tester
          .widget<Semantics>(
            find.byWidgetPredicate(
              (w) =>
                  w is Semantics &&
                  w.properties.label == AppStrings.zakatCashLabel,
            ),
          )
          .properties;

      expect(properties.value, '1200');
      expect(properties.hint, AppStrings.zakatCashHelper);
      expect(properties.textField, isTrue);
    });

    testWidgets('section titles are exposed as headings', (tester) async {
      await _pump(
        tester,
        const ZakatSectionTitle(AppStrings.zakatSectionAssets),
      );

      final properties = tester
          .widget<Semantics>(
            find.byWidgetPredicate(
              (w) =>
                  w is Semantics &&
                  w.properties.header == true &&
                  w.child is Text &&
                  (w.child as Text).data == AppStrings.zakatSectionAssets,
            ),
          )
          .properties;

      expect(properties.label, isNull);
      expect(find.text(AppStrings.zakatSectionAssets), findsOneWidget);
    });
  });
}

int _semanticsWithLabel(WidgetTester tester, String label) =>
    _semanticsMatching(tester, (p) => p.label == label);

int _semanticsMatching(
  WidgetTester tester,
  bool Function(SemanticsProperties properties) matches,
) {
  return find
      .byWidgetPredicate(
        (w) => w is Semantics && matches(w.properties),
      )
      .evaluate()
      .length;
}

Future<void> _pump(WidgetTester tester, Widget child) async {
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
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/zakat/data/models/zakat_currency.dart';
import 'package:sana/features/zakat/presentation/widgets/currency_selector.dart';

void main() {
  group('CurrencySelector', () {
    testWidgets('shows the selected currency and the broader currency list', (
      tester,
    ) async {
      await _pump(tester, ZakatCurrency.egyptianPound, (_) {});

      expect(find.text(AppStrings.zakatCurrencyTitle), findsOneWidget);
      expect(find.text(AppStrings.zakatCurrencyHelper), findsOneWidget);
      expect(find.text('جنيه مصري (EGP)'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<ZakatCurrency>));
      await tester.pumpAndSettle();

      // The menu is scrollable, so only a visible subset is built at a time.
      expect(find.byType(DropdownMenuItem<ZakatCurrency>), findsWidgets);
      expect(find.text(ZakatCurrency.saudiRiyal.menuLabel), findsOneWidget);
      expect(find.text(ZakatCurrency.euro.menuLabel), findsOneWidget);
      expect(find.text(ZakatCurrency.uaeDirham.menuLabel), findsOneWidget);
      expect(find.text(ZakatCurrency.usDollar.menuLabel), findsOneWidget);
    });

    testWidgets(
      'selecting a currency reports the chosen calculation currency',
      (
        tester,
      ) async {
        final selected = <ZakatCurrency>[];
        await _pump(tester, ZakatCurrency.egyptianPound, selected.add);

        await tester.tap(find.byType(DropdownButtonFormField<ZakatCurrency>));
        await tester.pumpAndSettle();
        await tester.tap(find.text(ZakatCurrency.saudiRiyal.menuLabel).last);
        await tester.pumpAndSettle();

        expect(selected, [ZakatCurrency.saudiRiyal]);
      },
    );
  });
}

Future<void> _pump(
  WidgetTester tester,
  ZakatCurrency currency,
  ValueChanged<ZakatCurrency> onChanged,
) async {
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
        body: CurrencySelector(currency: currency, onChanged: onChanged),
      ),
    ),
  );
}

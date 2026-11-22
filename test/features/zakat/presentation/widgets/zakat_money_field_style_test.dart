import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/theme/colors/colors_light.dart';
import 'package:sana/features/zakat/presentation/widgets/zakat_money_field.dart';

void main() {
  group('ZakatMoneyField soft-card styling', () {
    testWidgets('uses a filled field with a full rounded border', (
      tester,
    ) async {
      final controller = TextEditingController(text: '1200');
      addTearDown(controller.dispose);

      await _pump(tester, controller);
      final decoration = _decoration(tester);

      expect(decoration.filled, isTrue);
      expect(decoration.fillColor, ColorsLight.scaffoldBackgroundColor);
      expect(decoration.labelText, 'المبلغ');
      expect(decoration.helperText, 'أدخل المبلغ');

      final enabled = decoration.enabledBorder as OutlineInputBorder;
      expect(enabled.borderSide, isNot(BorderSide.none));
      expect(enabled.borderSide.color, ColorsLight.dividerColor);
      expect(enabled.borderRadius, BorderRadius.circular(AppSize.r16));

      expect(
        (decoration.focusedBorder as OutlineInputBorder).borderSide.color,
        ColorsLight.borderBrand,
      );
      expect(
        (decoration.errorBorder as OutlineInputBorder).borderSide.color,
        ColorsLight.errorText,
      );
      expect(decoration.errorStyle?.color, ColorsLight.errorText);
    });

    testWidgets('shows the validator error inside the card', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await _pump(tester, controller);
      await tester.enterText(find.byType(TextFormField), '9999999999999999');
      await tester.pump();

      expect(find.text(AppStrings.zakatValueTooLarge), findsOneWidget);
      expect(_decoration(tester).errorStyle?.color, ColorsLight.errorText);
    });
  });
}

InputDecoration _decoration(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).decoration!;

Future<void> _pump(
  WidgetTester tester,
  TextEditingController controller,
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
        body: ZakatMoneyField(
          controller: controller,
          label: 'المبلغ',
          helper: 'أدخل المبلغ',
        ),
      ),
    ),
  );
}

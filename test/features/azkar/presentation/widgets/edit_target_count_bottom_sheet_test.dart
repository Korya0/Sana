import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/edit_target_count_bottom_sheet.dart';

void main() {
  group('EditTargetCountBottomSheet', () {
    testWidgets('starts with the current target count', (tester) async {
      await _open(tester, initialCount: 33);

      expect(find.text('33'), findsOneWidget);
    });

    testWidgets('rejects an empty target and keeps the sheet open', (
      tester,
    ) async {
      int? captured;
      await _open(
        tester,
        initialCount: 33,
        onResult: (value) => captured = value,
      );

      await tester.enterText(find.byType(TextField), '0');
      await tester.tap(find.widgetWithText(AppTextButton, AppStrings.save));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.targetCountGreaterThanZero), findsOneWidget);
      expect(captured, isNull);
    });

    testWidgets('returns the new target count', (tester) async {
      int? captured;
      await _open(
        tester,
        initialCount: 33,
        onResult: (value) => captured = value,
      );

      await tester.enterText(find.byType(TextField), '15');
      await tester.tap(find.widgetWithText(AppTextButton, AppStrings.save));
      await tester.pumpAndSettle();

      expect(captured, 15);
    });
  });
}

Future<void> _open(
  WidgetTester tester, {
  required int initialCount,
  void Function(int?)? onResult,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: TextButton(
              onPressed: () async {
                final result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (_) =>
                      EditTargetCountBottomSheet(initialCount: initialCount),
                );
                onResult?.call(result);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

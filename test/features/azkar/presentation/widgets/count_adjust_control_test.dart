import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/presentation/widgets/common/count_adjust_control.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  group('CountAdjustControl', () {
    testWidgets('decrement and reset fire their callbacks when adjustable', (
      tester,
    ) async {
      var decrements = 0;
      var resets = 0;
      await pumpAzkarWidget(
        tester,
        CountAdjustControl(
          canAdjust: true,
          onDecrement: () => decrements++,
          onReset: () => resets++,
        ),
      );

      expect(find.byIcon(AppIcons.minus), findsOneWidget);
      expect(find.byKey(const ValueKey('count_reset_button')), findsOneWidget);

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('count_reset_button')));
      await tester.pumpAndSettle();

      expect(decrements, 1);
      expect(resets, 1);
    });

    testWidgets('both actions are disabled when count cannot be adjusted', (
      tester,
    ) async {
      var decrements = 0;
      var resets = 0;
      await pumpAzkarWidget(
        tester,
        CountAdjustControl(
          canAdjust: false,
          onDecrement: () => decrements++,
          onReset: () => resets++,
        ),
      );

      await tester.tap(find.byIcon(AppIcons.minus));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('count_reset_button')));
      await tester.pumpAndSettle();

      expect(decrements, 0);
      expect(resets, 0);
    });

    testWidgets('describes the reset action with a semantic label', (
      tester,
    ) async {
      await pumpAzkarWidget(
        tester,
        CountAdjustControl(
          canAdjust: true,
          onDecrement: () {},
          onReset: () {},
        ),
      );

      final reset = tester.widget<AppPressable>(
        find.byKey(const ValueKey('count_reset_button')),
      );
      expect(reset.semanticLabel, AppStrings.resetCounter);
    });
  });
}

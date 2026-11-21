import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_progress.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_actions_row.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows reset and copy actions and the counter', (tester) async {
    var resets = 0;
    var longResets = 0;
    var copies = 0;

    await pumpAzkarWidget(
      tester,
      ZikrActionsRow(
        progress: const ZikrProgress(
          completedCount: 2,
          totalCount: 5,
          remaining: 3,
          isCompleted: false,
          canReset: true,
        ),
        onResetTap: () => resets++,
        onResetLongPress: () => longResets++,
        onCopyTap: () => copies++,
      ),
    );

    expect(find.byIcon(AppIcons.minus), findsOneWidget);
    expect(find.byIcon(AppIcons.copy), findsOneWidget);

    // The decrement entry in the menu is wired to the tap callback.
    await tester.tap(find.byIcon(AppIcons.minus));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('count_decrement_action')));
    await tester.pumpAndSettle();
    expect(resets, 1);

    // The reset entry in the menu is wired to the long-press callback.
    await tester.tap(find.byIcon(AppIcons.minus));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('count_reset_action')));
    await tester.pumpAndSettle();
    expect(longResets, 1);
    expect(resets, 1);

    await tester.tap(find.byIcon(AppIcons.copy));
    await tester.pumpAndSettle();
    expect(copies, 1);
  });

  testWidgets('disables reset when the counter cannot be reset', (
    tester,
  ) async {
    var resets = 0;
    var longResets = 0;

    await pumpAzkarWidget(
      tester,
      ZikrActionsRow(
        progress: const ZikrProgress(
          completedCount: 0,
          totalCount: 5,
          remaining: 5,
          isCompleted: false,
          canReset: false,
        ),
        onResetTap: () => resets++,
        onResetLongPress: () => longResets++,
      ),
    );

    expect(find.byIcon(AppIcons.minus), findsOneWidget);
    await tester.tap(find.byIcon(AppIcons.minus));
    await tester.pumpAndSettle();

    // A disabled minus button does not open the count actions menu.
    expect(find.byKey(const ValueKey('count_decrement_action')), findsNothing);
    expect(find.byKey(const ValueKey('count_reset_action')), findsNothing);
    expect(resets, 0);
    expect(longResets, 0);
  });
}

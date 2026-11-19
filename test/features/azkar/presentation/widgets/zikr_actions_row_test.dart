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

    expect(find.byIcon(AppIcons.refresh), findsOneWidget);
    expect(find.byIcon(AppIcons.copy), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.refresh));
    await tester.pumpAndSettle();
    expect(resets, 1);

    await tester.longPress(find.byIcon(AppIcons.refresh));
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

    await tester.tap(find.byIcon(AppIcons.refresh));
    await tester.pumpAndSettle();
    await tester.longPress(find.byIcon(AppIcons.refresh));
    await tester.pumpAndSettle();
    expect(resets, 0);
    expect(longResets, 0);
  });
}

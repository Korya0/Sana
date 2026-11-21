import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_badge.dart';
import 'package:sana/features/azkar/presentation/widgets/common/zikr_card_shell.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders content, footer, badge and handles taps', (
    tester,
  ) async {
    var taps = 0;
    await pumpAzkarWidget(
      tester,
      ZikrCardShell(
        content: const Text('content'),
        footer: const Text('footer'),
        showBadge: true,
        onTap: () => taps++,
      ),
    );

    expect(find.text('content'), findsOneWidget);
    expect(find.text('footer'), findsOneWidget);
    expect(find.byType(ZikrBadge), findsOneWidget);

    await tester.tap(find.text('content'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('omits the badge when showBadge is false', (tester) async {
    await pumpAzkarWidget(
      tester,
      const ZikrCardShell(
        content: Text('content'),
        footer: Text('footer'),
        showBadge: false,
      ),
    );

    expect(find.byType(ZikrBadge), findsNothing);
  });
}

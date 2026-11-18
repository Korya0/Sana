import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/presentation/widgets/common/counter_ring.dart';
import 'package:sana/features/azkar/presentation/widgets/common/progress_ring.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('shows the remaining count and both progress rings', (
    tester,
  ) async {
    await pumpAzkarWidget(
      tester,
      const CounterRing(currentCount: 3, targetCount: 10),
    );

    expect(find.byType(ProgressRing), findsNWidgets(2));
    expect(find.byKey(const ValueKey('counter_7')), findsOneWidget);
  });

  testWidgets('switches to the done icon when the target is reached', (
    tester,
  ) async {
    await pumpAzkarWidget(
      tester,
      const CounterRing(currentCount: 10, targetCount: 10),
    );

    expect(find.byKey(const ValueKey('counter_done')), findsOneWidget);
    expect(find.byIcon(AppIcons.checkCircle), findsOneWidget);
  });

  testWidgets('free counting shows the current count', (tester) async {
    await pumpAzkarWidget(tester, const CounterRing(currentCount: 12));

    expect(find.byKey(const ValueKey('counter_12')), findsOneWidget);
  });
}

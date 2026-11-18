import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/widgets/common/counter_ring.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_counter_widgets.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('uses the tasbeeh number key for the remaining count', (
    tester,
  ) async {
    await pumpAzkarWidget(
      tester,
      const TasbeehCounter(currentCount: 3, targetCount: 10),
    );

    expect(find.byType(CounterRing), findsOneWidget);
    expect(find.byKey(const ValueKey('tasbeeh_counter_7')), findsOneWidget);
  });

  testWidgets('uses the tasbeeh done key when completed', (tester) async {
    await pumpAzkarWidget(
      tester,
      const TasbeehCounter(currentCount: 10, targetCount: 10),
    );

    expect(find.byKey(const ValueKey('tasbeeh_counter_done')), findsOneWidget);
  });
}

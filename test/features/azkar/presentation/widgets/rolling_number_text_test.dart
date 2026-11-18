import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/widgets/common/rolling_number_text.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('renders the whole value when animation is disabled', (
    tester,
  ) async {
    final value = ValueNotifier('12');
    addTearDown(value.dispose);

    await pumpAzkarWidget(
      tester,
      ValueListenableBuilder<String>(
        valueListenable: value,
        builder: (context, text, _) => RollingNumberText(
          value: text,
          style: const TextStyle(fontSize: 20),
          animate: false,
        ),
      ),
    );

    expect(find.text('12'), findsOneWidget);

    value.value = '13';
    await tester.pumpAndSettle();
    expect(find.text('13'), findsOneWidget);
    expect(find.text('12'), findsNothing);
  });

  testWidgets('rolls the old digit out and the new digit in', (tester) async {
    final value = ValueNotifier('1');
    addTearDown(value.dispose);

    await pumpAzkarWidget(
      tester,
      ValueListenableBuilder<String>(
        valueListenable: value,
        builder: (context, text, _) => RollingNumberText(
          value: text,
          style: const TextStyle(fontSize: 20),
          animate: true,
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);

    value.value = '2';
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}

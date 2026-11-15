import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_counter.dart';

void main() {
  group('ZikrCounter', () {
    testWidgets('shows the remaining repetitions and progress', (tester) async {
      await _pump(tester, completed: 3, total: 33);

      expect(find.byKey(const ValueKey('zikr_counter_number')), findsOneWidget);
      expect(find.byKey(const ValueKey('zikr_counter_done')), findsNothing);
      expect(_progressValue(tester), closeTo(3 / 33, 0.001));
    });

    testWidgets('shows the completion icon when the target is reached', (
      tester,
    ) async {
      await _pump(tester, completed: 33, total: 33);

      expect(find.byKey(const ValueKey('zikr_counter_done')), findsOneWidget);
      expect(find.byKey(const ValueKey('zikr_counter_number')), findsNothing);
      expect(_progressValue(tester), 1);
    });

    testWidgets('never divides by zero when the target is zero', (
      tester,
    ) async {
      await _pump(tester, completed: 0, total: 0);

      expect(find.byKey(const ValueKey('zikr_counter_done')), findsOneWidget);
      expect(_progressValue(tester), 0);
    });
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required int completed,
  required int total,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light,
    builder: (context, child) {
      AppSize.init(context);
      return Directionality(textDirection: TextDirection.rtl, child: child!);
    },
    home: Scaffold(
      body: Center(
        child: ZikrCounter(completedCount: completed, totalCount: total),
      ),
    ),
  ),
);

double _progressValue(WidgetTester tester) => tester
    .widgetList<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    )
    .last
    .value!;

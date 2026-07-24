import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/repeat_selector.dart';

void main() {
  group('RepeatSelector', () {
    testWidgets('should display 3 options: once, daily, custom', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: RepeatSelector(
              initialRepeatType: RepeatType.daily,
              initialDays: const <int>[],
              onChanged: (_, _) {},
            ),
          ),
        ),
      );

      expect(find.text('مرة واحدة'), findsOneWidget);
      expect(find.text('يومياً'), findsOneWidget);
      expect(find.text('أيام مخصصة'), findsOneWidget);
    });

    testWidgets('should show day buttons when custom is selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: RepeatSelector(
              initialRepeatType: RepeatType.custom,
              initialDays: const <int>[1],
              onChanged: (_, _) {},
            ),
          ),
        ),
      );

      expect(find.text('الإثنين'), findsOneWidget);
      expect(find.text('الثلاثاء'), findsOneWidget);
      expect(find.text('الأربعاء'), findsOneWidget);
      expect(find.text('الخميس'), findsOneWidget);
      expect(find.text('الجمعة'), findsOneWidget);
      expect(find.text('السبت'), findsOneWidget);
      expect(find.text('الأحد'), findsOneWidget);
    });
  });
}

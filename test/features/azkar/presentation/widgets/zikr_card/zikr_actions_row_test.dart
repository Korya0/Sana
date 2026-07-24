import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_actions_row.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart';

void main() {
  group('ZikrActionsRow', () {
    testWidgets('should display ZikrCounter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrActionsRow(
              remainingCount: 3,
              progress: 0,
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.byType(ZikrCounter), findsOneWidget);
    });

    testWidgets('should display ZikrCounter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrActionsRow(
              remainingCount: 5,
              progress: 0.5,
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.byType(ZikrCounter), findsOneWidget);
    });

    testWidgets('should apply Semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrActionsRow(
              remainingCount: 3,
              progress: 0,
              isCompleted: false,
            ),
          ),
        ),
      );

      // Verify semantics exist
      expect(
        find.bySemanticsLabel('خيارات مشاركة ونسخ الذكر'),
        findsOneWidget,
      );
    });

    testWidgets('should show completed semantics when completed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(
            body: ZikrActionsRow(
              remainingCount: 0,
              progress: 1,
              isCompleted: true,
            ),
          ),
        ),
      );

      // Should show check icon via ZikrCounter
      // Wait for animation
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });
  });
}

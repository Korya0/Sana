import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_counter.dart';

void main() {
  group('ZikrCounter', () {
    testWidgets('should display remaining count number when not completed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(
            extensions: [MyColors.light],
          ),
          home: const Scaffold(
            body: ZikrCounter(
              remainingCount: 3,
              progress: 0,
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should display check icon when completed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(
            extensions: [MyColors.light],
          ),
          home: const Scaffold(
            body: ZikrCounter(
              remainingCount: 0,
              progress: 1,
              isCompleted: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('should show CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(
            extensions: [MyColors.light],
          ),
          home: const Scaffold(
            body: ZikrCounter(
              remainingCount: 5,
              progress: 0.5,
              isCompleted: false,
            ),
          ),
        ),
      );

      // There should be circular progress indicators (background + animated)
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should use font24 when remainingCount <= 99', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(
            extensions: [MyColors.light],
          ),
          home: const Scaffold(
            body: ZikrCounter(
              remainingCount: 50,
              progress: 0,
              isCompleted: false,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('50'));
      // 24.r(context) on 800px default test screen = 24*(800/375)=51.2, clamped to [19.2, 33.6] = 33.6
      expect(textWidget.style?.fontSize, closeTo(33.6, 0.01));
    });

    testWidgets('should use font20 when remainingCount > 99', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(
            extensions: [MyColors.light],
          ),
          home: const Scaffold(
            body: ZikrCounter(
              remainingCount: 100,
              progress: 0,
              isCompleted: false,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('100'));
      // 20.r(context) on 800px default test screen = 20*(800/375)=42.67, clamped to [16, 28] = 28
      expect(textWidget.style?.fontSize, closeTo(28.0, 0.01));
    });

    testWidgets('AnimatedSwitcher should transition between count and icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(
            extensions: [MyColors.light],
          ),
          home: const Scaffold(
            body: ZikrCounter(
              remainingCount: 3,
              progress: 0,
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    });
  });
}

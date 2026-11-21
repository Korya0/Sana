import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_arc.dart';

void main() {
  group('TasbeehBeadArc', () {
    testWidgets('paints an arc in LTR and RTL', (tester) async {
      for (final rtl in [true, false]) {
        await _pump(tester, progress: 0.4, rtl: rtl);
        await tester.pumpAndSettle();

        expect(_painter(tester), isA<CustomPainter>());
      }
    });

    testWidgets('clamps out-of-range progress without throwing', (tester) async {
      for (final progress in [-1.0, 0.0, 0.5, 1.0, 2.0]) {
        await _pump(tester, progress: progress);
        await tester.pumpAndSettle();
        expect(_painter(tester), isA<CustomPainter>());
      }
    });

    testWidgets('repaints when progress changes', (tester) async {
      await _pump(tester, progress: 0.2);
      await tester.pumpAndSettle();
      final before = _painter(tester);

      await _pump(tester, progress: 0.9);
      await tester.pumpAndSettle();
      final after = _painter(tester);

      expect(after.shouldRepaint(before), isTrue);
    });

    testWidgets('reduced motion reaches the target without animating', (
      tester,
    ) async {
      await _pump(tester, progress: 0.6, reduceMotion: true);
      final reducedMotionPainter = _painter(tester);

      await _pump(tester, progress: 0.6, reduceMotion: false);
      await tester.pumpAndSettle();
      final animatedPainter = _painter(tester);

      expect(animatedPainter.shouldRepaint(reducedMotionPainter), isFalse);
    });
  });
}

CustomPainter _painter(WidgetTester tester) => tester.widget<CustomPaint>(
  find
      .descendant(
        of: find.byType(TasbeehBeadArc),
        matching: find.byType(CustomPaint),
      )
      .first,
).painter!;

Future<void> _pump(
  WidgetTester tester, {
  required double progress,
  bool rtl = true,
  bool reduceMotion = false,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      builder: (context, child) {
        AppSize.init(context);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: reduceMotion,
          ),
          child: Directionality(
            textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          ),
        );
      },
      home: Scaffold(
        body: SizedBox(
          width: 200,
          height: 100,
          child: TasbeehBeadArc(
            progress: progress,
            activeColor: Colors.green,
            inactiveColor: Colors.grey,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

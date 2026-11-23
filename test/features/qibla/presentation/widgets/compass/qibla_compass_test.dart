import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_dial_painter.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_kaaba_icon.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart';

import '../widget_test_harness.dart';

CompassDialPainter _painter(WidgetTester tester) => tester
    .widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter is CompassDialPainter,
      ),
    )
    .painter! as CompassDialPainter;

void main() {
  testWidgets('painter receives direction and facing values', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 135.0, phoneHeading: 0.0, isFacing: false),
    );

    final painter = _painter(tester);
    expect(painter.qiblaDirection, 135.0);
    expect(painter.isFacing, isFalse);
    expect(painter.heading, closeTo(0.0, 0.5));
    expect(find.byType(CompassKaabaIcon), findsOneWidget);
  });

  testWidgets('changing direction moves the kaaba badge', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 135.0, phoneHeading: 0.0, isFacing: false),
    );
    final before = tester.getTopLeft(find.byType(CompassKaabaIcon));

    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 0.0, phoneHeading: 0.0, isFacing: true),
    );
    final after = tester.getTopLeft(find.byType(CompassKaabaIcon));
    final painter = _painter(tester);

    expect(painter.qiblaDirection, 0.0);
    expect(painter.isFacing, isTrue);
    expect(after.dx, isNot(closeTo(before.dx, 0.5)));
  });

  testWidgets('shortest angular turn across zero', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 0.0, phoneHeading: 350.0, isFacing: false),
    );
    expect(_painter(tester).heading, closeTo(350.0, 0.5));

    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 0.0, phoneHeading: 10.0, isFacing: false),
    );

    expect(_painter(tester).heading, closeTo(10.0, 0.5));
  });

  testWidgets('shortest angular turn across zero in reverse', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 0.0, phoneHeading: 10.0, isFacing: false),
    );

    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 0.0, phoneHeading: 350.0, isFacing: false),
    );

    expect(_painter(tester).heading, closeTo(350.0, 0.5));
  });

  testWidgets('null heading stays at zero', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 45.0, phoneHeading: null, isFacing: false),
    );

    final painter = _painter(tester);
    expect(painter.heading, closeTo(0.0, 0.5));
    expect(painter.qiblaDirection, 45.0);
  });

  testWidgets('compass fits a small screen', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaCompass(direction: 120.0, phoneHeading: 60.0, isFacing: true),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(_painter(tester).isFacing, isTrue);
    expect(tester.takeException(), isNull);
  });
}

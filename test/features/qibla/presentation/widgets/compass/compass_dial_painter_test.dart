import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_dial_painter.dart';

import '../widget_test_harness.dart';

CompassDialPainter _painter({
  double heading = 10.0,
  double qiblaDirection = 45.0,
  bool isFacing = false,
  Color activeColor = Colors.green,
  Color neutralColor = Colors.grey,
  Color backgroundColor = Colors.white,
}) => CompassDialPainter(
  heading: heading,
  qiblaDirection: qiblaDirection,
  isFacing: isFacing,
  activeColor: activeColor,
  neutralColor: neutralColor,
  backgroundColor: backgroundColor,
);

void main() {
  test('stores painter values', () {
    final painter = _painter();

    expect(painter.heading, 10.0);
    expect(painter.qiblaDirection, 45.0);
    expect(painter.isFacing, isFalse);
    expect(painter.activeColor, Colors.green);
    expect(painter.neutralColor, Colors.grey);
    expect(painter.backgroundColor, Colors.white);
  });

  test('shouldRepaint is false for identical values', () {
    expect(_painter().shouldRepaint(_painter()), isFalse);
  });

  test('shouldRepaint is true when any value changes', () {
    final base = _painter();
    final changed = <CompassDialPainter>[
      _painter(heading: 20.0),
      _painter(qiblaDirection: 90.0),
      _painter(isFacing: true),
      _painter(activeColor: Colors.red),
      _painter(neutralColor: Colors.red),
      _painter(backgroundColor: Colors.red),
    ];

    for (final painter in changed) {
      expect(painter.shouldRepaint(base), isTrue);
    }
  });

  testWidgets('paint records a picture', (tester) async {
    await pumpQiblaWidget(tester, const SizedBox.shrink());

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    _painter(neutralColor: Colors.grey).paint(canvas, const Size(200, 200));
    final picture = recorder.endRecording();

    expect(picture, isNotNull);
    picture.dispose();
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart'
    as qibla_state;
import 'package:sana/features/qibla/presentation/widgets/compass/compass_dial_painter.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart'
    as compass_widget;
import 'package:sana/features/qibla/presentation/widgets/message_card.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_compass_content.dart';

import 'widget_test_harness.dart';

QiblaEntity _entity({double? phoneHeading, double direction = 135.0}) =>
    QiblaEntity(
      direction: direction,
      distanceKm: 1200.0,
      location: const QiblaLocation(latitude: 30.0, longitude: 31.0),
      phoneHeading: phoneHeading,
    );

CompassDialPainter _painter(WidgetTester tester) => tester
    .widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter is CompassDialPainter,
      ),
    )
    .painter! as CompassDialPainter;

void main() {
  testWidgets('forwards entity values to card and painter', (tester) async {
    final entity = _entity(phoneHeading: 42.0);
    final state = qibla_state.QiblaCompass(
      qiblaEntity: entity,
      heading: 42.0,
      tilt: 0.0,
      isLowAccuracy: false,
    );

    await pumpQiblaWidget(tester, QiblaCompassContent(state: state));

    final card = tester.widget<QiblaMessageCard>(find.byType(QiblaMessageCard));
    expect(card.title, state.guidanceTitle);
    expect(card.subtitle, state.guidanceSubtitle);
    expect(card.tone, state.guidanceTone);
    final painter = _painter(tester);
    expect(painter.qiblaDirection, 135.0);
    expect(find.byType(compass_widget.QiblaCompass), findsOneWidget);
  });

  testWidgets('handles a missing phone heading', (tester) async {
    final state = qibla_state.QiblaCompass(
      qiblaEntity: _entity(phoneHeading: null, direction: 90.0),
    );

    await pumpQiblaWidget(tester, QiblaCompassContent(state: state));

    final card = tester.widget<QiblaMessageCard>(find.byType(QiblaMessageCard));
    expect(card.subtitle, AppStrings.qiblaRemainingDegrees(0));
    expect(find.text(AppStrings.qiblaTurnLeft), findsOneWidget);
    final painter = _painter(tester);
    expect(painter.heading, closeTo(0.0, 0.5));
  });

  testWidgets('shows the facing message', (tester) async {
    final state = qibla_state.QiblaCompass(
      qiblaEntity: _entity(phoneHeading: 0.0, direction: 0.0),
    );

    await pumpQiblaWidget(tester, QiblaCompassContent(state: state));

    expect(find.text(AppStrings.qiblaFacing), findsOneWidget);
    final painter = _painter(tester);
    expect(painter.isFacing, isTrue);
  });

  testWidgets('fits a scaled small screen', (tester) async {
    final state = qibla_state.QiblaCompass(
      qiblaEntity: _entity(phoneHeading: 10.0),
    );

    await pumpQiblaWidget(
      tester,
      QiblaCompassContent(state: state),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.byType(QiblaMessageCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

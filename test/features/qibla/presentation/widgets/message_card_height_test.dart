import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/message_card.dart';

import 'widget_test_harness.dart';

QiblaEntity _entity({
  required double direction,
  required double heading,
  double tilt = 0,
  bool lowAccuracy = false,
}) => QiblaEntity(
  direction: direction,
  distanceKm: 0,
  location: const QiblaLocation(latitude: 21.4225, longitude: 39.8262),
  phoneHeading: heading,
  tilt: tilt,
  isLowAccuracy: lowAccuracy,
);

Widget _card(QiblaEntity entity) {
  final state = QiblaCompass(qiblaEntity: entity);
  return QiblaMessageCard(
    title: state.guidanceTitle,
    subtitle: state.guidanceSubtitle,
    tone: state.guidanceTone,
  );
}

void main() {
  testWidgets('card grows with the message and has a larger base padding', (
    tester,
  ) async {
    await pumpQiblaWidget(
      tester,
      SizedBox(width: 320, child: _card(_entity(direction: 0, heading: 0))),
      size: const Size(320, 640),
    );
    final shortHeight = tester.getSize(find.byType(AppSectionCard)).height;

    // A much longer message must make the card taller (no fixed height).
    await pumpQiblaWidget(
      tester,
      const SizedBox(
        width: 320,
        child: QiblaMessageCard(
          title: AppStrings.qiblaUnsupportedMessage,
          subtitle:
              '${AppStrings.qiblaUnsupportedMessage} ${AppStrings.qiblaFlatSurfaceGuidance} '
              '${AppStrings.qiblaFlatSurfaceGuidance} ${AppStrings.qiblaHoldInDirection}',
          tone: QiblaGuidanceTone.normal,
        ),
      ),
      size: const Size(320, 640),
    );
    final longHeight = tester.getSize(find.byType(AppSectionCard)).height;

    expect(longHeight, greaterThan(shortHeight));

    final card = tester.widget<AppSectionCard>(find.byType(AppSectionCard));
    expect(card.padding, EdgeInsets.all(AppSize.p20));
  });
}


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/message_card.dart';

import 'widget_test_harness.dart';

void main() {
  testWidgets('renders the given title and subtitle', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaMessageCard(
        title: AppStrings.qiblaTurnRight,
        subtitle: 'subtitle',
        tone: QiblaGuidanceTone.normal,
      ),
    );

    expect(find.text(AppStrings.qiblaTurnRight), findsOneWidget);
    expect(find.text('subtitle'), findsOneWidget);
  });

  testWidgets('success, error and normal tones use distinct colors', (
    tester,
  ) async {
    final colors = <Color?>[];
    for (final tone in QiblaGuidanceTone.values) {
      await pumpQiblaWidget(
        tester,
        QiblaMessageCard(
          title: AppStrings.qiblaTurnRight,
          subtitle: 'subtitle',
          tone: tone,
        ),
      );
      colors.add(
        tester.widget<Text>(find.text(AppStrings.qiblaTurnRight)).style!.color,
      );
    }

    expect(colors.toSet().length, 3);
  });

  testWidgets('fits a scaled small screen', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaMessageCard(
        title: AppStrings.qiblaLowAccuracy,
        subtitle: AppStrings.qiblaFlatSurfaceGuidance,
        tone: QiblaGuidanceTone.error,
      ),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.byType(QiblaMessageCard), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

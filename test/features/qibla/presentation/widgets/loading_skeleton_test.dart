import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart';
import 'package:sana/features/qibla/presentation/widgets/loading_skeleton.dart';
import 'package:sana/features/qibla/presentation/widgets/message_card.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_compass_content.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'widget_test_harness.dart';

void main() {
  testWidgets('shows the real screen inside a skeleton', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaLoadingSkeleton(),
      settle: false,
    );
    await tester.pump();

    expect(find.byWidgetPredicate((widget) => widget is Skeletonizer), findsOneWidget);
    expect(find.byType(QiblaCompassContent), findsOneWidget);
    expect(find.byType(QiblaMessageCard), findsOneWidget);
  });

  testWidgets('shows a compass placeholder', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaLoadingSkeleton(),
      settle: false,
    );
    await tester.pump();

    final compass = tester.widget<QiblaCompass>(find.byType(QiblaCompass));
    expect(compass.phoneHeading, isNull);
    expect(compass.isFacing, isFalse);
  });

  testWidgets('fits a scaled small screen', (tester) async {
    await pumpQiblaWidget(
      tester,
      const QiblaLoadingSkeleton(),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
      settle: false,
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

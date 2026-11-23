import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_state_content.dart';

import 'widget_test_harness.dart';

Widget _content(List<String> points) => QiblaStateContent(
  icon: Icons.info,
  iconColor: Colors.amber,
  title: AppStrings.qiblaPermissionTitle,
  points: points,
  buttonLabel: AppStrings.qiblaAllow,
  onButtonPressed: () {},
);

void main() {
  testWidgets('renders every point with a dot in order', (tester) async {
    final points = <String>[
      AppStrings.qiblaPermissionStep1,
      AppStrings.qiblaPermissionStep2,
    ];

    await pumpQiblaWidget(tester, _content(points));

    for (final point in points) {
      expect(find.text(point), findsOneWidget);
    }
    final dots = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
    );
    expect(dots, findsNWidgets(points.length));
    final context = tester.element(find.byType(QiblaStateContent));
    for (final dot in dots.evaluate()) {
      final decoration = (dot.widget as Container).decoration! as BoxDecoration;
      expect(decoration.color, context.color.textSecondary);
    }
    expect(
      tester.getTopLeft(find.text(points.first)).dy,
      lessThan(tester.getTopLeft(find.text(points.last)).dy),
    );
  });

  testWidgets('renders nothing for an empty list', (tester) async {
    await pumpQiblaWidget(tester, _content(const []));

    expect(find.text(AppStrings.qiblaPermissionStep1), findsNothing);
    expect(find.text(AppStrings.qiblaPermissionStep2), findsNothing);
  });

  testWidgets('keeps points readable at small scaled size', (tester) async {
    final points = <String>[
      AppStrings.qiblaDeniedStep1,
      AppStrings.qiblaDeniedStep2,
      AppStrings.qiblaDeniedStep3,
    ];

    await pumpQiblaWidget(
      tester,
      _content(points),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    for (final point in points) {
      expect(find.text(point), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}

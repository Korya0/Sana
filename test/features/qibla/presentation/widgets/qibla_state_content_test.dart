import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_state_content.dart';

import 'widget_test_harness.dart';

void main() {
  testWidgets('QiblaStateContent renders its inputs and taps', (tester) async {
    var calls = 0;
    await pumpQiblaWidget(
      tester,
      QiblaStateContent(
        icon: AppIcons.compass,
        iconColor: Colors.amber,
        title: AppStrings.qiblaPermissionTitle,
        points: const [
          AppStrings.qiblaPermissionStep1,
          AppStrings.qiblaPermissionStep2,
        ],
        buttonLabel: AppStrings.qiblaAllow,
        onButtonPressed: () => calls++,
      ),
    );

    expect(find.byIcon(AppIcons.compass), findsOneWidget);
    expect(find.text(AppStrings.qiblaPermissionTitle), findsOneWidget);
    expect(find.text(AppStrings.qiblaPermissionStep1), findsOneWidget);
    expect(find.text(AppStrings.qiblaPermissionStep2), findsOneWidget);
    await _tapButton(tester, AppStrings.qiblaAllow);
    expect(calls, 1);
  });

  testWidgets('permission content shows steps and calls back', (tester) async {
    var calls = 0;
    await pumpQiblaWidget(
      tester,
      QiblaStateContent(
        icon: AppIcons.location,
        iconColor: Colors.amber,
        title: AppStrings.qiblaPermissionTitle,
        points: const [
          AppStrings.qiblaPermissionStep1,
          AppStrings.qiblaPermissionStep2,
        ],
        buttonLabel: AppStrings.qiblaAllow,
        onButtonPressed: () => calls++,
      ),
    );

    await _expectContent(
      tester,
      AppStrings.qiblaPermissionTitle,
      const [
        AppStrings.qiblaPermissionStep1,
        AppStrings.qiblaPermissionStep2,
      ],
      AppStrings.qiblaAllow,
    );
    expect(find.byIcon(AppIcons.location), findsOneWidget);
    expect(
      tester.widget<Icon>(find.byIcon(AppIcons.location)).color,
      Colors.amber,
    );
    await _tapButton(tester, AppStrings.qiblaAllow);
    expect(calls, 1);
  });

  testWidgets('denied content shows instructions and calls back', (
    tester,
  ) async {
    var calls = 0;
    await pumpQiblaWidget(
      tester,
      QiblaStateContent(
        icon: AppIcons.locationOff,
        iconColor: Colors.amber,
        title: AppStrings.qiblaDeniedTitle,
        points: const [
          AppStrings.qiblaDeniedStep1,
          AppStrings.qiblaDeniedStep2,
          AppStrings.qiblaDeniedStep3,
          AppStrings.qiblaDeniedStep4,
        ],
        buttonLabel: AppStrings.qiblaOpenSettings,
        onButtonPressed: () => calls++,
      ),
    );

    await _expectContent(
      tester,
      AppStrings.qiblaDeniedTitle,
      const [
        AppStrings.qiblaDeniedStep1,
        AppStrings.qiblaDeniedStep2,
        AppStrings.qiblaDeniedStep3,
        AppStrings.qiblaDeniedStep4,
      ],
      AppStrings.qiblaOpenSettings,
    );
    await _tapButton(tester, AppStrings.qiblaOpenSettings);
    expect(calls, 1);
  });

  testWidgets('failed content shows steps and calls back', (tester) async {
    var calls = 0;
    await pumpQiblaWidget(
      tester,
      QiblaStateContent(
        icon: AppIcons.gpsNotFixed,
        iconColor: Colors.amber,
        title: AppStrings.qiblaFailedTitle,
        points: const [
          AppStrings.qiblaFailedStep1,
          AppStrings.qiblaFailedStep2,
        ],
        buttonLabel: AppStrings.qiblaOpenLocationSettings,
        onButtonPressed: () => calls++,
      ),
    );

    await _expectContent(
      tester,
      AppStrings.qiblaFailedTitle,
      const [AppStrings.qiblaFailedStep1, AppStrings.qiblaFailedStep2],
      AppStrings.qiblaOpenLocationSettings,
    );
    await _tapButton(tester, AppStrings.qiblaOpenLocationSettings);
    expect(calls, 1);
  });

  testWidgets('unsupported content shows the back action', (tester) async {
    var calls = 0;
    await pumpQiblaWidget(
      tester,
      QiblaStateContent(
        icon: AppIcons.compass,
        iconColor: Colors.amber,
        title: AppStrings.qiblaUnsupportedTitle,
        points: const [AppStrings.qiblaUnsupportedMessage],
        buttonLabel: AppStrings.back,
        onButtonPressed: () => calls++,
      ),
    );

    await _expectContent(
      tester,
      AppStrings.qiblaUnsupportedTitle,
      const [AppStrings.qiblaUnsupportedMessage],
      AppStrings.back,
    );
    await _tapButton(tester, AppStrings.back);
    expect(calls, 1);
  });

  testWidgets('state content fits a scaled small screen', (tester) async {
    await pumpQiblaWidget(
      tester,
      QiblaStateContent(
        icon: AppIcons.locationOff,
        iconColor: Colors.amber,
        title: AppStrings.qiblaDeniedTitle,
        points: const [
          AppStrings.qiblaDeniedStep1,
          AppStrings.qiblaDeniedStep2,
          AppStrings.qiblaDeniedStep3,
          AppStrings.qiblaDeniedStep4,
        ],
        buttonLabel: AppStrings.qiblaOpenSettings,
        onButtonPressed: () {},
      ),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text(AppStrings.qiblaDeniedTitle), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _expectContent(
  WidgetTester tester,
  String title,
  List<String> points,
  String label,
) async {
  expect(find.text(title), findsOneWidget);
  for (final point in points) {
    expect(find.text(point), findsOneWidget);
  }
  expect(find.text(label), findsOneWidget);
}

Future<void> _tapButton(WidgetTester tester, String label) async {
  final button = find.ancestor(
    of: find.text(label),
    matching: find.byType(AppPressable),
  );
  expect(button, findsOneWidget);
  await tester.tap(button);
  await tester.pump(const Duration(milliseconds: 200));
}

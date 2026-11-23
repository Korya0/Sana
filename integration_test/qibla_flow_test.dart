import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_compass_content.dart';

import 'qibla_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Qibla full flow — from open to measured direction', () {
    testWidgets('no compass sensor shows unsupported and can go back', (
      tester,
    ) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(hasSensor: false),
      );
      addTearDown(repo.dispose);

      expect(find.byType(QiblaView), findsOneWidget);
      expect(find.text(AppStrings.qiblaUnsupportedTitle), findsOneWidget);
      expect(find.text(AppStrings.qiblaUnsupportedMessage), findsOneWidget);
      expect(find.text(AppStrings.qiblaHeader), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sensor failure shows unsupported with failure message', (
      tester,
    ) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(sensorFailure: true),
      );
      addTearDown(repo.dispose);

      expect(find.text(AppStrings.qiblaUnsupportedTitle), findsOneWidget);
      expect(find.text(AppStrings.qiblaUnsupportedMessage), findsOneWidget);
    });

    testWidgets('permission not granted shows the permission screen', (
      tester,
    ) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(permissionGranted: false),
      );
      addTearDown(repo.dispose);

      expect(find.text(AppStrings.qiblaPermissionTitle), findsOneWidget);
      expect(find.text(AppStrings.qiblaPermissionStep1), findsOneWidget);
      expect(find.text(AppStrings.qiblaPermissionStep2), findsOneWidget);
      expect(find.text(AppStrings.qiblaAllow), findsOneWidget);
    });

    testWidgets('permission failure shows the permission screen', (tester) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(permissionFailure: true),
      );
      addTearDown(repo.dispose);

      expect(find.text(AppStrings.qiblaPermissionTitle), findsOneWidget);
    });

    testWidgets('tapping allow requests then reaches the compass', (tester) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(permissionGranted: false, requestGrants: true),
      );
      addTearDown(repo.dispose);

      final allow = find.ancestor(
        of: find.text(AppStrings.qiblaAllow),
        matching: find.byType(AppPressable),
      );
      expect(allow, findsOneWidget);
      await tester.tap(allow);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(repo.requestPermissionCalls, 1);
      expect(find.byType(QiblaCompassContent), findsOneWidget);
      expect(repo.calculateCalls, 1);
    });

    testWidgets('permission denied after request shows denied steps', (
      tester,
    ) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(permissionGranted: false, requestGrants: false),
      );
      addTearDown(repo.dispose);

      final allow = find.ancestor(
        of: find.text(AppStrings.qiblaAllow),
        matching: find.byType(AppPressable),
      );
      await tester.tap(allow);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text(AppStrings.qiblaDeniedTitle), findsOneWidget);
      expect(find.text(AppStrings.qiblaDeniedStep1), findsOneWidget);
      expect(find.text(AppStrings.qiblaOpenSettings), findsOneWidget);

      final settings = find.ancestor(
        of: find.text(AppStrings.qiblaOpenSettings),
        matching: find.byType(AppPressable),
      );
      await tester.tap(settings);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(repo.openAppSettingsCalls, 1);
    });

    testWidgets('calculate failure shows failed steps and opens location settings', (
      tester,
    ) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(calculateFailure: true),
      );
      addTearDown(repo.dispose);

      expect(find.text(AppStrings.qiblaFailedTitle), findsOneWidget);
      expect(find.text(AppStrings.qiblaFailedStep1), findsOneWidget);
      expect(find.text(AppStrings.qiblaOpenLocationSettings), findsOneWidget);

      final settings = find.ancestor(
        of: find.text(AppStrings.qiblaOpenLocationSettings),
        matching: find.byType(AppPressable),
      );
      await tester.tap(settings);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(repo.openLocationSettingsCalls, 1);
    });

    testWidgets('granted permission reaches the measured compass', (
      tester,
    ) async {
      final repo = await pumpQiblaFlow(tester, QiblaScenario());
      addTearDown(repo.dispose);

      expect(find.byType(QiblaCompassContent), findsOneWidget);
      expect(find.byType(QiblaView), findsOneWidget);
      expect(repo.calculateCalls, 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('stream events update the compass guidance', (tester) async {
      final repo = await pumpQiblaFlow(tester, QiblaScenario());
      addTearDown(repo.dispose);

      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(QiblaCompassContent), findsOneWidget);

      repo.emitCompass(
        const CompassSensorData(heading: 10.0, tilt: 0.0, isLowAccuracy: true),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(AppStrings.qiblaLowAccuracy), findsOneWidget);
    });

    testWidgets('entry from settings navigates into qibla', (tester) async {
      final repo = await pumpQiblaFlow(
        tester,
        QiblaScenario(),
        navigateFromSettings: true,
      );
      addTearDown(repo.dispose);

      expect(find.byType(QiblaView), findsOneWidget);
      expect(find.text(AppStrings.qiblaHeader), findsOneWidget);
    });
  });
}

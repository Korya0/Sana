import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/calculate_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_compass_sensor_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/check_location_permission_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_location_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_app_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/open_location_settings_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/request_location_permission_use_case.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';
import 'package:sana/features/qibla/presentation/views/qibla_view.dart';
import 'package:sana/features/qibla/presentation/widgets/loading_skeleton.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_compass_content.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_state_content.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/compass_dial_painter.dart';
import 'package:sana/features/qibla/presentation/widgets/compass/qibla_compass.dart'
    as compass_widget;
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/widget_test_harness.dart';

void main() {
  testWidgets('shows the app bar title', (tester) async {
    await _pumpState(tester, const QiblaPermission());

    expect(find.text(AppStrings.qiblaHeader), findsOneWidget);
  });

  for (final state in <QiblaState>[
    const QiblaInitial(),
    const QiblaLoading(),
  ]) {
    testWidgets('renders skeleton for ${state.runtimeType}', (tester) async {
      await _pumpState(tester, state);

      expect(find.byType(QiblaLoadingSkeleton), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is Skeletonizer), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('permission button calls requestPermission', (tester) async {
    final cubit = await _pumpState(tester, const QiblaPermission());

    expect(find.text(AppStrings.qiblaPermissionTitle), findsOneWidget);
    expect(find.text(AppStrings.qiblaAllow), findsOneWidget);
    final button = find.ancestor(
      of: find.text(AppStrings.qiblaAllow),
      matching: find.byType(AppPressable),
    );
    expect(button, findsOneWidget);
    expect(find.bySemanticsLabel(AppStrings.qiblaAllow), findsOneWidget);

    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 200));

    expect(cubit.requestPermissionCalls, 1);
  });

  testWidgets('compass state shows card and painter values', (tester) async {
    await _pumpState(tester, _facingState());

    expect(find.byType(QiblaCompassContent), findsOneWidget);
    expect(find.byType(compass_widget.QiblaCompass), findsOneWidget);
    expect(find.text(AppStrings.qiblaFacing), findsOneWidget);
    final painter = tester
        .widget<CustomPaint>(
          find.byWidgetPredicate(
            (widget) =>
                widget is CustomPaint && widget.painter is CompassDialPainter,
          ),
        )
        .painter! as CompassDialPainter;
    expect(painter.qiblaDirection, 0.0);
    expect(painter.isFacing, isTrue);
  });

  testWidgets('denied button calls openAppSettings', (tester) async {
    final cubit = await _pumpState(
      tester,
      const QiblaDenied(AppStrings.qiblaDeniedTitle),
    );

    expect(find.text(AppStrings.qiblaDeniedTitle), findsOneWidget);
    final button = find.ancestor(
      of: find.text(AppStrings.qiblaOpenSettings),
      matching: find.byType(AppPressable),
    );
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 200));

    expect(cubit.openAppSettingsCalls, 1);
  });

  testWidgets('failed button calls openLocationSettings', (tester) async {
    final cubit = await _pumpState(
      tester,
      const QiblaFailed(AppStrings.qiblaFailedTitle),
    );

    expect(find.text(AppStrings.qiblaFailedTitle), findsOneWidget);
    final button = find.ancestor(
      of: find.text(AppStrings.qiblaOpenLocationSettings),
      matching: find.byType(AppPressable),
    );
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 200));

    expect(cubit.openLocationSettingsCalls, 1);
  });

  testWidgets('unsupported button pops without cubit calls', (tester) async {
    final cubit = await _pumpState(
      tester,
      const QiblaUnsupported(AppStrings.qiblaUnsupportedMessage),
      withBackStack: true,
    );

    expect(find.text(AppStrings.qiblaUnsupportedTitle), findsOneWidget);
    final button = find.ancestor(
      of: find.text(AppStrings.back),
      matching: find.byType(AppPressable),
    );
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump(const Duration(milliseconds: 200));

    expect(cubit.requestPermissionCalls, 0);
    expect(cubit.openAppSettingsCalls, 0);
    expect(cubit.openLocationSettingsCalls, 0);
    expect(tester.takeException(), isNull);
  });

  for (final size in <Size>[
    const Size(320, 640),
    const Size(400, 900),
    const Size(600, 1000),
  ]) {
    testWidgets('permission state fits $size', (tester) async {
      await _pumpState(tester, const QiblaPermission(), size: size);

      expect(find.byType(AppPressable), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('states fit scaled text', (tester) async {
    await _pumpState(
      tester,
      const QiblaPermission(),
      size: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.byType(AppPressable), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('state screens do not scroll when content fits', (tester) async {
    await _pumpState(tester, const QiblaPermission());

    var checkedPositions = 0;
    for (final element in find.byType(Scrollable).evaluate()) {
      final position = (element.widget as Scrollable).controller?.position;
      if (position == null) continue;
      checkedPositions++;
      expect(
        position.extentAfter,
        0.0,
        reason: 'Qibla state screens must not scroll when all content fits',
      );
    }
    expect(checkedPositions, greaterThan(0));
  });

  testWidgets('state screens do not scroll with a top safe-area inset',
      (tester) async {
    tester.view.padding =
        const FakeViewPadding(left: 0, top: 47, right: 0, bottom: 34);
    await _pumpState(tester, const QiblaPermission());

    var checkedPositions = 0;
    for (final element in find.byType(Scrollable).evaluate()) {
      final position = (element.widget as Scrollable).controller?.position;
      if (position == null) continue;
      checkedPositions++;
      expect(
        position.extentAfter,
        0.0,
        reason: 'the app-bar height must not become scroll extent',
      );
    }
    expect(checkedPositions, greaterThan(0));
  });

  testWidgets('state content still scrolls for genuinely tall content',
      (tester) async {
    await pumpQiblaWidget(
      tester,
      CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Qibla')),
          SliverFillRemaining(
            hasScrollBody: false,
            child: QiblaStateContent(
              icon: Icons.location_on,
              iconColor: Colors.green,
              title: 'Long instructions',
              points: List<String>.generate(40, (i) => 'Instruction $i'),
              buttonLabel: 'Allow',
              onButtonPressed: () {},
            ),
          ),
        ],
      ),
    );

    final extents = find.byType(Scrollable).evaluate().map(
          (element) => (element.widget as Scrollable).controller?.position,
        );
    expect(
      extents.any((position) => position != null && position.extentAfter > 0),
      isTrue,
      reason: 'legitimate long content must remain scrollable',
    );
  });
}

QiblaCompass _facingState() => const QiblaCompass(
  qiblaEntity: QiblaEntity(
    direction: 0.0,
    distanceKm: 1000.0,
    location: QiblaLocation(latitude: 21.0, longitude: 39.0),
    phoneHeading: 0.0,
    tilt: 0.0,
    isLowAccuracy: false,
  ),
  heading: 0.0,
  tilt: 0.0,
  isLowAccuracy: false,
);

Future<_FakeQiblaCubit> _pumpState(
  WidgetTester tester,
  QiblaState state, {
  Size size = const Size(400, 900),
  TextScaler textScaler = TextScaler.noScaling,
  bool withBackStack = false,
}) async {
  final cubit = _fakeCubit()..setTestState(state);
  sl.registerFactory<QiblaCubit>(() => cubit);
  addTearDown(() async {
    if (sl.isRegistered<QiblaCubit>()) sl.unregister<QiblaCubit>();
    if (!cubit.isClosed) await cubit.close();
  });

  final router = withBackStack
      ? GoRouter(
          initialLocation: '/home',
          routes: <RouteBase>[
            ShellRoute(
              builder: (context, state, child) => child,
              routes: <RouteBase>[
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const SizedBox.shrink(),
                ),
                GoRoute(
                  path: '/qibla',
                  builder: (context, state) => const QiblaView(),
                ),
              ],
            ),
          ],
        )
      : GoRouter(
          initialLocation: '/qibla',
          routes: <RouteBase>[
            GoRoute(
              path: '/qibla',
              builder: (context, state) => const QiblaView(),
            ),
          ],
        );

  final isLoading = state is QiblaInitial || state is QiblaLoading;
  await pumpQiblaWidget(
    tester,
    const QiblaView(),
    size: size,
    textScaler: textScaler,
    router: router,
    settle: !isLoading,
  );
  if (isLoading) await tester.pump();
  if (withBackStack) {
    router.push('/qibla');
    await tester.pumpAndSettle();
  }
  return cubit;
}

_FakeQiblaCubit _fakeCubit() {
  final repository = _IdleRepository();
  return _FakeQiblaCubit(
    checkCompassSensor: CheckCompassSensorUseCase(repository),
    checkLocationPermission: CheckLocationPermissionUseCase(repository),
    requestLocationPermission: RequestLocationPermissionUseCase(repository),
    calculateQiblaDirection: CalculateQiblaDirectionUseCase(repository),
    getCompassStream: GetCompassStreamUseCase(repository),
    getLocationStream: GetLocationStreamUseCase(repository),
    openAppSettings: OpenAppSettingsUseCase(repository),
    openLocationSettings: OpenLocationSettingsUseCase(repository),
  );
}

class _FakeQiblaCubit extends QiblaCubit {
  _FakeQiblaCubit({
    required super.checkCompassSensor,
    required super.checkLocationPermission,
    required super.requestLocationPermission,
    required super.calculateQiblaDirection,
    required super.getCompassStream,
    required super.getLocationStream,
    required super.openAppSettings,
    required super.openLocationSettings,
  });

  int requestPermissionCalls = 0;
  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;

  void setTestState(QiblaState state) => emit(state);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestPermission() async {
    requestPermissionCalls++;
  }

  @override
  Future<void> openAppSettings() async {
    openAppSettingsCalls++;
  }

  @override
  Future<void> openLocationSettings() async {
    openLocationSettingsCalls++;
  }
}

class _IdleRepository implements QiblaRepository {
  @override
  Future<Result<bool>> hasCompassSensor() async => const Success(true);

  @override
  Future<Result<bool>> checkLocationPermission() async => const Success(false);

  @override
  Future<Result<bool>> requestLocationPermission() async =>
      const Success(false);

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async =>
      const Success(
        QiblaEntity(
          direction: 0.0,
          distanceKm: 0.0,
          location: QiblaLocation(latitude: 0.0, longitude: 0.0),
        ),
      );

  @override
  Future<Result<LocationModel>> getCurrentLocation() async =>
      const Success(LocationModel(latitude: 0.0, longitude: 0.0));

  @override
  Stream<CompassSensorData> getCompassStream() => const Stream.empty();

  @override
  Stream<LocationModel> getLocationStream() => const Stream.empty();

  @override
  Future<Result<void>> openAppSettings() async => const Success(null);

  @override
  Future<Result<void>> openLocationSettings() async => const Success(null);
}

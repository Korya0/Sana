import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
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

void main() {
  late _FakeRepository repository;
  late _TestableQiblaCubit cubit;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    repository = _FakeRepository();
    cubit = _TestableQiblaCubit(
      checkCompassSensor: CheckCompassSensorUseCase(repository),
      checkLocationPermission: CheckLocationPermissionUseCase(repository),
      requestLocationPermission: RequestLocationPermissionUseCase(repository),
      calculateQiblaDirection: CalculateQiblaDirectionUseCase(repository),
      getCompassStream: GetCompassStreamUseCase(repository),
      getLocationStream: GetLocationStreamUseCase(repository),
      openAppSettings: OpenAppSettingsUseCase(repository),
      openLocationSettings: OpenLocationSettingsUseCase(repository),
    );
    repository.enqueueQibla(_qibla());
  });

  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
    await repository.dispose();
  });

  test('starts with QiblaInitial', () {
    expect(cubit.state, isA<QiblaInitial>());
  });

  test('initialize emits unsupported when no compass sensor', () async {
    repository.hasSensor = false;
    final states = expectLater(
      cubit.stream,
      emitsInOrder(<Matcher>[isA<QiblaUnsupported>()]),
    );

    await cubit.initialize();
    await states;

    expect(cubit.state, isA<QiblaUnsupported>());
    expect(
      (cubit.state as QiblaUnsupported).message,
      AppStrings.qiblaUnsupportedMessage,
    );
    expect(repository.hasSensorCalls, 1);
    expect(repository.checkPermissionCalls, 0);
  });

  test('initialize forwards sensor failure message', () async {
    repository.sensorFailure = const SensorFailure(message: 'sensor error');

    await cubit.initialize();

    expect(cubit.state, isA<QiblaUnsupported>());
    expect((cubit.state as QiblaUnsupported).message, 'sensor error');
    expect(repository.checkPermissionCalls, 0);
  });

  test('initialize emits permission when location is not granted', () async {
    repository.hasSensor = true;
    repository.permissionGranted = false;

    await cubit.initialize();

    expect(cubit.state, isA<QiblaPermission>());
    expect(repository.calculateCalls, 0);
  });

  test('initialize emits loading then compass with entity values', () async {
    repository.permissionGranted = true;
    final states = expectLater(
      cubit.stream,
      emitsInOrder(<Matcher>[isA<QiblaLoading>(), isA<QiblaCompass>()]),
    );

    await cubit.initialize();
    await states;

    final state = cubit.state as QiblaCompass;
    expect(state.heading, 10.0);
    expect(state.tilt, 1.0);
    expect(state.isLowAccuracy, isFalse);
    expect(state.qiblaEntity.direction, 135.0);
    expect(state.qiblaEntity.distanceKm, 1200.0);
    expect(repository.calculateCalls, 1);
  });

  test('initialize emits failed when direction calculation fails', () async {
    repository.permissionGranted = true;
    repository.calculationFailure = const LocationFailure(message: 'gps off');

    await cubit.initialize();

    expect(cubit.state, isA<QiblaFailed>());
    expect((cubit.state as QiblaFailed).message, 'gps off');
  });

  test('requestPermission emits loading then denied', () async {
    repository.permissionGranted = false;
    final states = expectLater(
      cubit.stream,
      emitsInOrder(<Matcher>[isA<QiblaLoading>(), isA<QiblaDenied>()]),
    );

    await cubit.requestPermission();
    await states;

    expect((cubit.state as QiblaDenied).message, AppStrings.qiblaDeniedTitle);
    expect(repository.requestPermissionCalls, 1);
  });

  test('requestPermission forwards permission failure message', () async {
    repository.requestFailure = const PermissionFailure(message: 'blocked');

    await cubit.requestPermission();

    expect(cubit.state, isA<QiblaDenied>());
    expect((cubit.state as QiblaDenied).message, 'blocked');
  });

  test('requestPermission emits compass when granted', () async {
    repository.permissionGranted = true;

    await cubit.requestPermission();

    expect(cubit.state, isA<QiblaCompass>());
    expect((cubit.state as QiblaCompass).qiblaEntity.direction, 135.0);
  });

  test('startTracking emits failed with failure message', () async {
    repository.calculationFailure = const GeneralFailure(message: 'no fix');

    await cubit.startTracking();

    expect(cubit.state, isA<QiblaFailed>());
    expect((cubit.state as QiblaFailed).message, 'no fix');
  });

  test('compass stream updates heading tilt and low accuracy', () async {
    await cubit.startTracking();
    expect(cubit.state, isA<QiblaCompass>());

    final next = cubit.stream.firstWhere(
      (state) => state is QiblaCompass && state.heading == 180.0,
    );
    repository.compassController.add(
      const CompassSensorData(heading: 180.0, tilt: 9.0, isLowAccuracy: true),
    );
    final updated = (await next) as QiblaCompass;

    expect(updated.heading, 180.0);
    expect(updated.tilt, 9.0);
    expect(updated.isLowAccuracy, isTrue);
    expect(updated.qiblaEntity.phoneHeading, 180.0);
    expect(updated.qiblaEntity.tilt, 9.0);
    expect(updated.qiblaEntity.isLowAccuracy, isTrue);
    expect(updated.qiblaEntity.direction, 135.0);
    expect(updated.qiblaEntity.distanceKm, 1200.0);
  });

  test('location stream recomputes and keeps sensor values', () async {
    await cubit.startTracking();
    final sensorNext = cubit.stream.firstWhere(
      (state) => state is QiblaCompass && state.heading == 42.0,
    );
    repository.compassController.add(
      const CompassSensorData(heading: 42.0, tilt: 7.0, isLowAccuracy: true),
    );
    await sensorNext;

    repository.enqueueQibla(
      _qibla(direction: 200.0, phoneHeading: 0.0, tilt: 0.0),
    );
    final locationNext = cubit.stream.firstWhere(
      (state) => state is QiblaCompass && state.qiblaEntity.direction == 200.0,
    );
    repository.locationController.add(
      const LocationModel(latitude: 31.0, longitude: 32.0),
    );
    final updated = (await locationNext) as QiblaCompass;

    expect(updated.qiblaEntity.direction, 200.0);
    expect(updated.qiblaEntity.phoneHeading, 42.0);
    expect(updated.qiblaEntity.tilt, 7.0);
    expect(updated.qiblaEntity.isLowAccuracy, isTrue);
    expect(updated.heading, 42.0);
    expect(repository.calculateCalls, 2);
  });

  test('recheckOnResume skips pending states', () async {
    for (final state in <QiblaState>[
      const QiblaInitial(),
      const QiblaPermission(),
      const QiblaLoading(),
      const QiblaUnsupported('unsupported'),
    ]) {
      cubit.setTestState(state);
      await cubit.recheckOnResume();
      expect(repository.checkPermissionCalls, 0);
    }
  });

  test('recheckOnResume starts tracking when permission is granted', () async {
    cubit.setTestState(const QiblaDenied(AppStrings.qiblaDeniedTitle));
    repository.permissionGranted = true;

    await cubit.recheckOnResume();

    expect(cubit.state, isA<QiblaCompass>());
    expect(repository.checkPermissionCalls, 1);
  });

  test('recheckOnResume emits denied when permission was revoked', () async {
    cubit.setTestState(_compassState());
    repository.permissionGranted = false;

    await cubit.recheckOnResume();

    expect(cubit.state, isA<QiblaDenied>());
    expect((cubit.state as QiblaDenied).message, AppStrings.qiblaDeniedTitle);
  });

  test('recheckOnResume does not re-emit an existing denied state', () async {
    cubit.setTestState(const QiblaDenied('already denied'));
    repository.permissionGranted = false;
    var emissions = 0;
    final subscription = cubit.stream.listen((_) => emissions++);

    await cubit.recheckOnResume();
    await subscription.cancel();

    expect(emissions, 0);
    expect((cubit.state as QiblaDenied).message, 'already denied');
  });

  test('resumed lifecycle triggers recheckOnResume', () async {
    cubit.setTestState(_compassState());
    repository.permissionGranted = false;
    final denied = cubit.stream.firstWhere((state) => state is QiblaDenied);

    cubit.didChangeAppLifecycleState(AppLifecycleState.paused);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(cubit.state, isA<QiblaCompass>());

    cubit.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await denied;

    expect(cubit.state, isA<QiblaDenied>());
  });

  test('settings methods delegate without changing state', () async {
    var emissions = 0;
    final subscription = cubit.stream.listen((_) => emissions++);

    await cubit.openAppSettings();
    await cubit.openLocationSettings();
    await subscription.cancel();

    expect(repository.openAppSettingsCalls, 1);
    expect(repository.openLocationSettingsCalls, 1);
    expect(emissions, 0);
    expect(cubit.state, isA<QiblaInitial>());
  });

  test('close stops emissions and delegation', () async {
    await cubit.close();
    expect(cubit.isClosed, isTrue);

    await cubit.initialize();
    await cubit.recheckOnResume();
    await cubit.requestPermission();
    await cubit.startTracking();
    await cubit.openAppSettings();
    await cubit.openLocationSettings();
    cubit.didChangeAppLifecycleState(AppLifecycleState.resumed);
    repository.compassController.add(
      const CompassSensorData(heading: 90.0, tilt: 0.0),
    );
    await Future<void>.delayed(const Duration(milliseconds: 1));

    expect(cubit.state, isA<QiblaInitial>());
    expect(repository.hasSensorCalls, 0);
    expect(repository.checkPermissionCalls, 0);
    expect(repository.requestPermissionCalls, 0);
    expect(repository.calculateCalls, 0);
    expect(repository.openAppSettingsCalls, 0);
    expect(repository.openLocationSettingsCalls, 0);
  });
}

QiblaEntity _qibla({
  double direction = 135.0,
  double phoneHeading = 10.0,
  double tilt = 1.0,
  bool isLowAccuracy = false,
}) => QiblaEntity(
  direction: direction,
  distanceKm: 1200.0,
  location: const QiblaLocation(latitude: 30.0, longitude: 31.0),
  phoneHeading: phoneHeading,
  tilt: tilt,
  isLowAccuracy: isLowAccuracy,
);

QiblaCompass _compassState() => QiblaCompass(
  qiblaEntity: _qibla(),
  heading: 10.0,
  tilt: 1.0,
  isLowAccuracy: false,
);

class _TestableQiblaCubit extends QiblaCubit {
  _TestableQiblaCubit({
    required super.checkCompassSensor,
    required super.checkLocationPermission,
    required super.requestLocationPermission,
    required super.calculateQiblaDirection,
    required super.getCompassStream,
    required super.getLocationStream,
    required super.openAppSettings,
    required super.openLocationSettings,
  });

  void setTestState(QiblaState state) => emit(state);
}

class _FakeRepository implements QiblaRepository {
  bool hasSensor = true;
  bool permissionGranted = true;
  Failure? sensorFailure;
  Failure? permissionFailure;
  Failure? requestFailure;
  Failure? calculationFailure;

  final List<QiblaEntity> _qiblaQueue = <QiblaEntity>[];
  QiblaEntity? _lastQibla;
  final StreamController<CompassSensorData> compassController =
      StreamController<CompassSensorData>.broadcast();
  final StreamController<LocationModel> locationController =
      StreamController<LocationModel>.broadcast();

  int hasSensorCalls = 0;
  int checkPermissionCalls = 0;
  int requestPermissionCalls = 0;
  int calculateCalls = 0;
  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;

  void enqueueQibla(QiblaEntity qibla) => _qiblaQueue.add(qibla);

  Future<void> dispose() async {
    await compassController.close();
    await locationController.close();
  }

  @override
  Future<Result<bool>> hasCompassSensor() async {
    hasSensorCalls++;
    if (sensorFailure != null) return FailureResult(sensorFailure!);
    return Success(hasSensor);
  }

  @override
  Future<Result<bool>> checkLocationPermission() async {
    checkPermissionCalls++;
    if (permissionFailure != null) return FailureResult(permissionFailure!);
    return Success(permissionGranted);
  }

  @override
  Future<Result<bool>> requestLocationPermission() async {
    requestPermissionCalls++;
    if (requestFailure != null) return FailureResult(requestFailure!);
    return Success(permissionGranted);
  }

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async {
    calculateCalls++;
    if (calculationFailure != null) return FailureResult(calculationFailure!);
    if (_qiblaQueue.isNotEmpty) _lastQibla = _qiblaQueue.removeAt(0);
    if (_lastQibla == null) {
      return const FailureResult(CacheFailure(message: 'no data'));
    }
    return Success(_lastQibla!);
  }

  @override
  Future<Result<LocationModel>> getCurrentLocation() async =>
      const Success(LocationModel(latitude: 30.0, longitude: 31.0));

  @override
  Stream<CompassSensorData> getCompassStream() => compassController.stream;

  @override
  Stream<LocationModel> getLocationStream() => locationController.stream;

  @override
  Future<Result<void>> openAppSettings() async {
    openAppSettingsCalls++;
    return const Success(null);
  }

  @override
  Future<Result<void>> openLocationSettings() async {
    openLocationSettingsCalls++;
    return const Success(null);
  }
}

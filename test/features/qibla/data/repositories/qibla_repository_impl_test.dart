import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/location_result.dart';
import 'package:sana/core/services/location/location_service.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/qibla/data/data_sources/compass_local_data_source.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository_impl.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const permissionChannel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );
  const geolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late _FakeLocationDataSource locationDataSource;
  late _FakeCompassDataSource compassDataSource;
  late _RecordingLogger logger;
  late _FakeLocationService locationService;
  late QiblaRepositoryImpl repository;

  setUp(() {
    locationDataSource = _FakeLocationDataSource(
      location: const LocationModel(
        latitude: 30.0444,
        longitude: 31.2357,
        heading: 45,
      ),
    );
    compassDataSource = _FakeCompassDataSource();
    logger = _RecordingLogger();
    locationService = _FakeLocationService();
    repository = QiblaRepositoryImpl(
      locationDataSource,
      compassDataSource,
      logger,
      locationService,
    );
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(permissionChannel, null);
    messenger.setMockMethodCallHandler(geolocatorChannel, null);
  });

  const worldLocations = <_WorldCase>[
    _WorldCase('Cairo', 30.0444, 31.2357, 136.137, 1287.216),
    _WorldCase('London', 51.5074, -0.1278, 118.987, 4793.775),
    _WorldCase('Sydney', -33.8688, 151.2093, 277.5, 13236.255),
    _WorldCase('NewYork', 40.7128, -74.006, 58.482, 10306.306),
    _WorldCase('Equator', 0, 0, 58.508, 4932.87),
    _WorldCase('DateLine', -10, 179.9, 291.532, 15571.495),
  ];

  for (final place in worldLocations) {
    test('calculateQiblaDirection computes bearing at ${place.name}', () async {
      locationDataSource.location = LocationModel(
        latitude: place.latitude,
        longitude: place.longitude,
        heading: 45,
      );

      final result = await repository.calculateQiblaDirection();

      final success = result as Success<QiblaEntity>;
      expect(success.data.direction, closeTo(place.bearing, 0.5));
      expect(success.data.distanceKm, closeTo(place.distance, 5));
      expect(success.data.location.latitude, place.latitude);
      expect(success.data.location.longitude, place.longitude);
      expect(success.data.phoneHeading, 45);
      expect(locationDataSource.callCount, 1);
    });
  }

  test('calculateQiblaDirection returns zero distance at Kaaba', () async {
    locationDataSource.location = const LocationModel(
      latitude: 21.4225,
      longitude: 39.8262,
    );

    final result = await repository.calculateQiblaDirection();

    final success = result as Success<QiblaEntity>;
    expect(success.data.distanceKm, closeTo(0, 0.001));
    expect(success.data.direction, closeTo(0, 0.001));
  });

  test('calculateQiblaDirection returns LocationFailure on error', () async {
    locationDataSource.error = StateError('gps unavailable');

    final result = await repository.calculateQiblaDirection();

    final failure = result as FailureResult<QiblaEntity>;
    expect(failure.failure, isA<LocationFailure>());
    expect(failure.failure.message, AppStrings.qiblaFailedTitle);
    expect(logger.errorCount, 1);
  });

  test('getCurrentLocation returns the data source model', () async {
    final result = await repository.getCurrentLocation();

    final success = result as Success<LocationModel>;
    expect(success.data.latitude, 30.0444);
    expect(success.data.longitude, 31.2357);
    expect(locationDataSource.callCount, 1);
  });

  test('getCurrentLocation returns LocationFailure on error', () async {
    locationDataSource.error = StateError('no fix');

    final result = await repository.getCurrentLocation();

    final failure = result as FailureResult<LocationModel>;
    expect(failure.failure, isA<LocationFailure>());
    expect(failure.failure.message, AppStrings.qiblaFailedTitle);
    expect(logger.errorCount, 1);
  });

  test('hasCompassSensor returns the data source value', () async {
    final result = await repository.hasCompassSensor();

    final success = result as Success<bool>;
    expect(success.data, isTrue);
    expect(compassDataSource.hasSensorCalls, 1);
  });

  test('hasCompassSensor returns SensorFailure on error', () async {
    compassDataSource.error = StateError('sensor missing');

    final result = await repository.hasCompassSensor();

    final failure = result as FailureResult<bool>;
    expect(failure.failure, isA<SensorFailure>());
    expect(failure.failure.message, AppStrings.qiblaUnsupportedMessage);
    expect(logger.errorCount, 1);
  });

  test('checkLocationPermission delegates to the shared service', () async {
    locationService.permission = const Success(false);

    final result = await repository.checkLocationPermission();

    final success = result as Success<bool>;
    expect(success.data, isFalse);
    expect(locationService.checkCalls, 1);
  });

  test('checkLocationPermission passes through PermissionFailure', () async {
    locationService.permission = const Result.failure(
      PermissionFailure(message: AppStrings.qiblaDeniedTitle),
    );

    final result = await repository.checkLocationPermission();

    final failure = result as FailureResult<bool>;
    expect(failure.failure, isA<PermissionFailure>());
    expect(failure.failure.message, AppStrings.qiblaDeniedTitle);
  });

  test('requestLocationPermission delegates to the shared service', () async {
    locationService.permission = const Success(true);

    final result = await repository.requestLocationPermission();

    final success = result as Success<bool>;
    expect(success.data, isTrue);
    expect(locationService.requestCalls, 1);
  });

  test('requestLocationPermission passes through PermissionFailure', () async {
    locationService.permission = const Result.failure(
      PermissionFailure(message: AppStrings.qiblaDeniedTitle),
    );

    final result = await repository.requestLocationPermission();

    final failure = result as FailureResult<bool>;
    expect(failure.failure, isA<PermissionFailure>());
  });

  test('getCompassStream passes through sensor data', () async {
    final data = await repository.getCompassStream().first;

    expect(data.heading, 12.0);
    expect(data.tilt, 3.0);
    expect(compassDataSource.streamCalls, 1);
  });

  test('getLocationStream passes through locations', () async {
    final data = await repository.getLocationStream().first;

    expect(data.latitude, 30.0444);
    expect(data.heading, 45);
    expect(locationDataSource.streamCalls, 1);
  });

  test('openAppSettings delegates to the shared service', () async {
    locationService.settingsResult = const Success<void>(null);

    final result = await repository.openAppSettings();

    expect(result, isA<Success<void>>());
    expect(locationService.appSettingsCalls, 1);
  });

  test('openAppSettings passes through GeneralFailure', () async {
    locationService.settingsResult = const Result.failure(
      GeneralFailure(message: AppStrings.qiblaDeniedTitle),
    );

    final result = await repository.openAppSettings();

    final failure = result as FailureResult<void>;
    expect(failure.failure, isA<GeneralFailure>());
    expect(failure.failure.message, AppStrings.qiblaDeniedTitle);
  });

  test('openLocationSettings delegates to the shared service', () async {
    locationService.settingsResult = const Success<void>(null);

    final result = await repository.openLocationSettings();

    expect(result, isA<Success<void>>());
    expect(locationService.locationSettingsCalls, 1);
  });

  test('openLocationSettings passes through GeneralFailure', () async {
    locationService.settingsResult = const Result.failure(
      GeneralFailure(message: AppStrings.qiblaFailedTitle),
    );

    final result = await repository.openLocationSettings();

    final failure = result as FailureResult<void>;
    expect(failure.failure, isA<GeneralFailure>());
    expect(failure.failure.message, AppStrings.qiblaFailedTitle);
  });
}

class _FakeLocationService implements LocationService {
  Result<bool> permission = const Success(true);
  Result<void> settingsResult = const Success<void>(null);
  int checkCalls = 0;
  int requestCalls = 0;
  int appSettingsCalls = 0;
  int locationSettingsCalls = 0;

  @override
  Future<Result<bool>> checkPermission() async {
    checkCalls++;
    return permission;
  }

  @override
  Future<Result<bool>> requestPermission() async {
    requestCalls++;
    return permission;
  }

  @override
  Future<Result<LocationResult>> getCurrentLocation() async => const Result.failure(
        LocationFailure(message: AppStrings.qiblaFailedTitle),
      );

  @override
  Stream<LocationResult> watchLocation() => const Stream.empty();

  @override
  Future<Result<void>> openAppSettings() async {
    appSettingsCalls++;
    return settingsResult;
  }

  @override
  Future<Result<void>> openLocationSettings() async {
    locationSettingsCalls++;
    return settingsResult;
  }
}

class _WorldCase {
  const _WorldCase(
    this.name,
    this.latitude,
    this.longitude,
    this.bearing,
    this.distance,
  );

  final String name;
  final double latitude;
  final double longitude;
  final double bearing;
  final double distance;
}

class _FakeLocationDataSource implements LocationLocalDataSource {
  _FakeLocationDataSource({required this.location});

  LocationModel location;
  Object? error;
  int callCount = 0;
  int streamCalls = 0;

  @override
  Future<LocationModel> getCurrentLocation() async {
    callCount++;
    if (error != null) throw error!;
    return location;
  }

  @override
  Stream<LocationModel> onLocationChanged() {
    streamCalls++;
    return Stream.value(location);
  }
}

class _FakeCompassDataSource implements CompassLocalDataSource {
  bool hasSensor = true;
  Object? error;
  int hasSensorCalls = 0;
  int streamCalls = 0;

  @override
  Future<bool> hasCompassSensor() async {
    hasSensorCalls++;
    if (error != null) throw error!;
    return hasSensor;
  }

  @override
  Stream<CompassSensorData> onCompassChanged() {
    streamCalls++;
    return Stream.value(
      const CompassSensorData(heading: 12, tilt: 3),
    );
  }
}

class _RecordingLogger extends AppLogger {
  int errorCount = 0;

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    errorCount++;
  }
}

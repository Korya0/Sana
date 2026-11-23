import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/check_location_permission_use_case.dart';

void main() {
  test('delegates and returns granted permission', () async {
    final repository = _FakeRepository(granted: true);

    final result = await CheckLocationPermissionUseCase(repository)();

    expect((result as Success<bool>).data, isTrue);
    expect(repository.callCount, 1);
  });

  test('delegates and returns denied permission', () async {
    final repository = _FakeRepository(granted: false);

    final result = await CheckLocationPermissionUseCase(repository)();

    expect((result as Success<bool>).data, isFalse);
    expect(repository.callCount, 1);
  });

  test('passes failure result through', () async {
    final repository = _FakeRepository(granted: true, failing: true);

    final result = await CheckLocationPermissionUseCase(repository)();

    final failure = result as FailureResult<bool>;
    expect(failure.failure, isA<PermissionFailure>());
    expect(repository.callCount, 1);
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({required this.granted, this.failing = false});

  final bool granted;
  final bool failing;
  int callCount = 0;

  @override
  Future<Result<bool>> checkLocationPermission() async {
    callCount++;
    if (failing) {
      return const Result.failure(PermissionFailure(message: 'test failure'));
    }
    return Result.success(granted);
  }

  @override
  Future<Result<bool>> hasCompassSensor() async => const Result.success(true);

  @override
  Future<Result<bool>> requestLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<LocationModel>> getCurrentLocation() async =>
      const Result.success(LocationModel(latitude: 0, longitude: 0));

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async =>
      const Result.success(
        QiblaEntity(
          direction: 0,
          distanceKm: 0,
          location: QiblaLocation(latitude: 0, longitude: 0),
        ),
      );

  @override
  Stream<CompassSensorData> getCompassStream() => const Stream.empty();

  @override
  Stream<LocationModel> getLocationStream() => const Stream.empty();

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async =>
      const Result.success(null);
}

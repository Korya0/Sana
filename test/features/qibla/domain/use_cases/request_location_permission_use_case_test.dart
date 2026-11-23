import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/request_location_permission_use_case.dart';

void main() {
  test('returns true when permission is granted', () async {
    final repository = _FakeRepository(granted: true);

    final result = await RequestLocationPermissionUseCase(repository)();

    final success = result as Success<bool>;
    expect(success.data, true);
  });

  test('returns false when permission is denied', () async {
    final repository = _FakeRepository(granted: false);

    final result = await RequestLocationPermissionUseCase(repository)();

    final success = result as Success<bool>;
    expect(success.data, false);
  });

  test('passes failure result through unchanged', () async {
    final repository = _FakeRepository(granted: true, failing: true);

    final result = await RequestLocationPermissionUseCase(repository)();

    final failure = result as FailureResult<bool>;
    expect(failure.failure, isA<PermissionFailure>());
    expect(failure.failure.message, 'permission request failed');
    expect(repository.callCount, 1);
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({required this.granted, this.failing = false});

  final bool granted;
  final bool failing;
  int callCount = 0;

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async {
    return const Result.success(
      QiblaEntity(
        direction: 0,
        distanceKm: 0,
        location: QiblaLocation(latitude: 0, longitude: 0),
      ),
    );
  }

  @override
  Future<Result<bool>> hasCompassSensor() async => const Result.success(true);

  @override
  Future<Result<bool>> requestLocationPermission() async {
    callCount++;
    if (failing) {
      return const Result.failure(
        PermissionFailure(message: 'permission request failed'),
      );
    }
    return Result.success(granted);
  }

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async => const Result.success(null);

  @override
  Future<Result<bool>> checkLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<LocationModel>> getCurrentLocation() async =>
      const Result.success(LocationModel(latitude: 0, longitude: 0));

  @override
  Stream<CompassSensorData> getCompassStream() => const Stream.empty();

  @override
  Stream<LocationModel> getLocationStream() => const Stream.empty();
}

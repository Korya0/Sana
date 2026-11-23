import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/entities/compass_sensor_data.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/use_cases/calculate_qibla_direction_use_case.dart';

void main() {
  test('returns QiblaEntity from repository', () async {
    const location = QiblaLocation(latitude: 30.0444, longitude: 31.2357);
    const qibla = QiblaEntity(
      direction: 135.0,
      distanceKm: 1200.0,
      location: location,
    );
    final repository = _FakeRepository(qibla: qibla);

    final result = await CalculateQiblaDirectionUseCase(repository)();

    final success = result as Success<QiblaEntity>;
    expect(success.data.direction, 135.0);
    expect(success.data.distanceKm, 1200.0);
    expect(repository.callCount, 1);
  });

  test('returns failure when repository fails', () async {
    final repository = _FakeRepository(failure: true);

    final result = await CalculateQiblaDirectionUseCase(repository)();

    expect(result, isA<FailureResult>());
  });
}

class _FakeRepository implements QiblaRepository {
  _FakeRepository({this.qibla, this.failure = false});

  final QiblaEntity? qibla;
  final bool failure;
  int callCount = 0;

  @override
  Future<Result<QiblaEntity>> calculateQiblaDirection() async {
    callCount++;
    if (failure) {
      return const Result.failure(
        CacheFailure(message: 'test error'),
      );
    }
    return Result.success(qibla!);
  }

  @override
  Future<Result<bool>> hasCompassSensor() async => const Result.success(true);

  @override
  Future<Result<bool>> requestLocationPermission() async =>
      const Result.success(true);

  @override
  Future<Result<void>> openAppSettings() async => const Result.success(null);

  @override
  Future<Result<void>> openLocationSettings() async =>
      const Result.success(null);

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

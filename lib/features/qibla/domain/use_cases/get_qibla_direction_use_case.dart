import 'package:sana/core/network/result.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class GetQiblaDirectionUseCase {
  GetQiblaDirectionUseCase(this._repository);
  final QiblaRepository _repository;

  Result<QiblaDirectionEntity> call() {
    final locationResult = _repository.getUserLocation();

    return switch (locationResult) {
      FailureResult(:final failure) => Result<QiblaDirectionEntity>.failure(
        failure,
      ),
      Success(data: final location) => _calculateQibla(location),
    };
  }

  Result<QiblaDirectionEntity> _calculateQibla(QiblaLocationEntity location) {
    final directionResult = _repository.calculateQiblaDirection(
      location.latitude,
      location.longitude,
    );
    final distanceResult = _repository.calculateDistanceToKaaba(
      location.latitude,
      location.longitude,
    );

    return switch (directionResult) {
      FailureResult(:final failure) => Result<QiblaDirectionEntity>.failure(
        failure,
      ),
      Success(data: final direction) => switch (distanceResult) {
        FailureResult(:final failure) => Result<QiblaDirectionEntity>.failure(
          failure,
        ),
        Success(data: final distance) => Result.success(
          QiblaDirectionEntity(
            qiblaDirection: direction,
            distanceToKaaba: distance,
            userLocation: location,
          ),
        ),
      },
    };
  }
}

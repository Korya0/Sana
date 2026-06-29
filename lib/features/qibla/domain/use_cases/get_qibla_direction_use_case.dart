import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class GetQiblaDirectionUseCase {
  GetQiblaDirectionUseCase(this._repository);
  final IQiblaRepository _repository;

  ApiResult<QiblaDirectionEntity> call() {
    final locationResult = _repository.getUserLocation();

    return switch (locationResult) {
      ApiFailure(:final failure) => ApiResult<QiblaDirectionEntity>.failure(
        failure,
      ),
      Success(data: final location) => () {
        final directionResult = _repository.calculateQiblaDirection(
          location.latitude,
          location.longitude,
        );
        final distanceResult = _repository.calculateDistanceToKaaba(
          location.latitude,
          location.longitude,
        );

        return switch (directionResult) {
          ApiFailure(:final failure) => ApiResult<QiblaDirectionEntity>.failure(
            failure,
          ),
          Success(data: final direction) => switch (distanceResult) {
            ApiFailure(:final failure) =>
              ApiResult<QiblaDirectionEntity>.failure(failure),
            Success(data: final distance) => ApiResult.success(
              QiblaDirectionEntity(
                qiblaDirection: direction,
                distanceToKaaba: distance,
                userLocation: location,
              ),
            ),
          },
        };
      }(),
    };
  }
}

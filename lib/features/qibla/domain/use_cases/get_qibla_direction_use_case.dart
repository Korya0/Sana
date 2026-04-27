import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class GetQiblaDirectionUseCase {
  GetQiblaDirectionUseCase(this._repository);
  final IQiblaRepository _repository;

  ApiResult<QiblaDirectionEntity> call() {
    final locationResult = _repository.getUserLocation();

    return locationResult.when(
      success: (location) {
        final directionResult = _repository.calculateQiblaDirection(
          location.latitude,
          location.longitude,
        );
        final distanceResult = _repository.calculateDistanceToKaaba(
          location.latitude,
          location.longitude,
        );

        return directionResult.when(
          success: (direction) {
            return distanceResult.when(
              success: (distance) => ApiResult.success(
                QiblaDirectionEntity(
                  qiblaDirection: direction,
                  distanceToKaaba: distance,
                ),
              ),
              failure: ApiResult.failure,
            );
          },
          failure: ApiResult.failure,
        );
      },
      failure: ApiResult.failure,
    );
  }
}

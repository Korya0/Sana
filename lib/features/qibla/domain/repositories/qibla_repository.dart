import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

abstract interface class IQiblaRepository {
  ApiResult<QiblaLocationEntity> getUserLocation();

  ApiResult<double> calculateQiblaDirection(double lat, double lng);

  ApiResult<double> calculateDistanceToKaaba(double lat, double lng);
}

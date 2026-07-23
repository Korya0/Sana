import 'package:sana/core/network/result.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';

abstract interface class IQiblaRepository {
  Result<QiblaLocationEntity> getUserLocation();

  Result<double> calculateQiblaDirection(double lat, double lng);

  Result<double> calculateDistanceToKaaba(double lat, double lng);

  String? getQiblaMode();
  Future<void> saveQiblaMode(String mode);
  Stream<double?>? getCompassStream();
}

import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/services/qibla_service.dart';

class GetQiblaCompassStreamUseCase {
  GetQiblaCompassStreamUseCase(this._service);
  final IQiblaService _service;

  Stream<QiblaCompassDataEntity> call({
    required Stream<double> headingStream,
    required double qiblaDirection,
  }) {
    return headingStream.map((heading) {
      final diff = _service.calculateAngleDifference(heading, qiblaDirection);
      
      return QiblaCompassDataEntity(
        compassRotation: _service.calculateCompassRotation(heading),
        arrowRotation: _service.calculateArrowRotation(diff),
        angleDifference: diff,
        qiblaMessage: _service.getQiblaMessage(diff),
      );
    });
  }
}

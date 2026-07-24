import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/domain/services/qibla_service.dart';

class GetQiblaCompassStreamUseCase {
  GetQiblaCompassStreamUseCase({
    required QiblaService service,
    required QiblaRepository repository,
  }) : _service = service,
       _repository = repository;

  final QiblaService _service;
  final QiblaRepository _repository;

  Stream<QiblaCompassDataEntity>? call({
    required double qiblaDirection,
  }) {
    final stream = _repository.getCompassStream();
    if (stream == null) return null;

    return stream.map((heading) {
      final safeHeading = heading ?? 0.0;
      final diff = _service.calculateAngleDifference(
        safeHeading,
        qiblaDirection,
      );

      return QiblaCompassDataEntity(
        compassRotation: _service.calculateCompassRotation(safeHeading),
        arrowRotation: _service.calculateArrowRotation(diff),
        angleDifference: diff,
        qiblaMessage: _service.getQiblaMessage(diff),
      );
    });
  }
}

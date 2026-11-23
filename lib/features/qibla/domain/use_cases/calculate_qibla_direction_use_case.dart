import 'package:sana/core/error/result.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class CalculateQiblaDirectionUseCase {
  CalculateQiblaDirectionUseCase(this._repository);

  final QiblaRepository _repository;

  // Calculates Qibla direction
  Future<Result<QiblaEntity>> call() => _repository.calculateQiblaDirection();
}

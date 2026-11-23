import 'package:sana/features/qibla/data/models/location_model.dart';
import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class GetLocationStreamUseCase {
  GetLocationStreamUseCase(this._repository);

  final QiblaRepository _repository;

  // Location stream
  Stream<LocationModel> call() => _repository.getLocationStream();
}

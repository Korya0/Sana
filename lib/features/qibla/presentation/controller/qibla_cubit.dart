import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit(this._qiblaRepository) : super(QiblaInitial());
  final QiblaRepository _qiblaRepository;

  void initQibla() {
    emit(QiblaLoading());
    final locationResult = _qiblaRepository.getUserLocation();

    locationResult.fold(
      (failure) => emit(QiblaError(failure.message)),
      (location) {
        final lat = location['lat']!;
        final lng = location['lng']!;

        final directionResult = _qiblaRepository.calculateQiblaDirection(
          lat,
          lng,
        );
        final distanceResult = _qiblaRepository.calculateDistanceToKaaba(
          lat,
          lng,
        );

        directionResult.fold(
          (failure) => emit(QiblaError(failure.message)),
          (qiblaDirection) => distanceResult.fold(
            (failure) => emit(QiblaError(failure.message)),
            (distanceToKaaba) => emit(
              QiblaLoaded(
                qiblaDirection: qiblaDirection,
                distanceToKaaba: distanceToKaaba,
              ),
            ),
          ),
        );
      },
    );
  }
}

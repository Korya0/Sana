import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/data/repos/qibla_repository.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({required this.repository}) : super(const QiblaInitial());
  final IQiblaRepository repository;

  void initQibla() {
    emit(const QiblaLoading());
    repository.getUserLocation().when(
      success: (location) {
        final directionResult = repository.calculateQiblaDirection(
          location.latitude,
          location.longitude,
        );
        final distanceResult = repository.calculateDistanceToKaaba(
          location.latitude,
          location.longitude,
        );

        directionResult.when(
          success: (qiblaDirection) {
            distanceResult.when(
              success: (distanceToKaaba) => emit(
                QiblaLoaded(
                  qiblaDirection: qiblaDirection,
                  distanceToKaaba: distanceToKaaba,
                ),
              ),
              failure: (failure) => emit(QiblaError(failure.message)),
            );
          },
          failure: (failure) => emit(QiblaError(failure.message)),
        );
      },
      failure: (failure) => emit(QiblaError(failure.message)),
    );
  }
}

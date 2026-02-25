import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository.dart';

part 'qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({required this.repository}) : super(QiblaInitial());
  final IQiblaRepository repository;

  void initQibla() {
    emit(QiblaLoading());
    final locationResult = repository.getUserLocation();

    locationResult.fold(
      (failure) => emit(QiblaError(failure.message)),
      (location) {
        final lat = location['lat']!;
        final lng = location['lng']!;

        final directionResult = repository.calculateQiblaDirection(lat, lng);
        final distanceResult = repository.calculateDistanceToKaaba(lat, lng);

        directionResult.fold(
          (failure) => emit(QiblaError(failure.message)),
          (qiblaDirection) {
            distanceResult.fold(
              (failure) => emit(QiblaError(failure.message)),
              (distanceToKaaba) => emit(
                QiblaLoaded(
                  qiblaDirection: qiblaDirection,
                  distanceToKaaba: distanceToKaaba,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

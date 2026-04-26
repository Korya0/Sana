import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/location_manager/data/constants/location_api_constants.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({required this.repository}) : super(const QiblaState.initial());
  final IQiblaRepository repository;

  void initQibla() {
    emit(const QiblaState.loading());
    repository.getUserLocation().when(
      success: (location) {
        final lat = location[LocationApiConstants.keyLatitude]!;
        final lng = location[LocationApiConstants.keyLongitude]!;

        final directionResult = repository.calculateQiblaDirection(lat, lng);
        final distanceResult = repository.calculateDistanceToKaaba(lat, lng);

        directionResult.when(
          success: (qiblaDirection) {
            distanceResult.when(
              success: (distanceToKaaba) => emit(
                QiblaState.loaded(
                  qiblaDirection: qiblaDirection,
                  distanceToKaaba: distanceToKaaba,
                ),
              ),
              failure: (failure) => emit(QiblaState.error(failure.message)),
            );
          },
          failure: (failure) => emit(QiblaState.error(failure.message)),
        );
      },
      failure: (failure) => emit(QiblaState.error(failure.message)),
    );
  }
}

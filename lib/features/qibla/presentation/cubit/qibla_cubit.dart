import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/data/repositories/qibla_repository.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit(this._qiblaRepository) : super(QiblaInitial());
  final QiblaRepository _qiblaRepository;

  void initQibla() {
    emit(QiblaLoading());
    try {
      final location = _qiblaRepository.getUserLocation();
      final lat = location['lat']!;
      final lng = location['lng']!;

      final qiblaDirection = _qiblaRepository.calculateQiblaDirection(lat, lng);
      final distanceToKaaba = _qiblaRepository.calculateDistanceToKaaba(
        lat,
        lng,
      );

      emit(
        QiblaLoaded(
          qiblaDirection: qiblaDirection,
          distanceToKaaba: distanceToKaaba,
        ),
      );
    } on Exception catch (e) {
      emit(QiblaError('Failed to calculate Qibla direction: $e'));
    }
  }
}

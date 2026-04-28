import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    required GetQiblaDirectionUseCase getQiblaDirectionUseCase,
    required GetQiblaCompassStreamUseCase getQiblaCompassStreamUseCase,
  }) : _getQiblaDirectionUseCase = getQiblaDirectionUseCase,
       _getQiblaCompassStreamUseCase = getQiblaCompassStreamUseCase,
       super(const QiblaInitial());

  final GetQiblaDirectionUseCase _getQiblaDirectionUseCase;
  final GetQiblaCompassStreamUseCase _getQiblaCompassStreamUseCase;

  void initQibla() {
    emit(const QiblaLoading());
    _getQiblaDirectionUseCase().when(
      success: (data) => emit(
        QiblaSuccess(
          qiblaDirection: data.qiblaDirection,
          distanceToKaaba: data.distanceToKaaba,
        ),
      ),
      failure: (failure) => emit(QiblaError(failure.message)),
    );
  }

  Stream<QiblaCompassDataEntity>? getQiblaStream(double qiblaDirection) {
    final stream = FlutterCompass.events;
    if (stream == null) return null;

    return _getQiblaCompassStreamUseCase(
      headingStream: stream.map((event) => event.heading ?? 0),
      qiblaDirection: qiblaDirection,
    );
  }
}

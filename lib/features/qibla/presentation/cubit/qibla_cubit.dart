import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_direction_use_case.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({required GetQiblaDirectionUseCase getQiblaDirectionUseCase})
    : _getQiblaDirectionUseCase = getQiblaDirectionUseCase,
      super(const QiblaInitial());

  final GetQiblaDirectionUseCase _getQiblaDirectionUseCase;

  void initQibla() {
    emit(const QiblaLoading());
    _getQiblaDirectionUseCase().when(
      success: (data) => emit(
        QiblaLoaded(
          qiblaDirection: data.qiblaDirection,
          distanceToKaaba: data.distanceToKaaba,
        ),
      ),
      failure: (failure) => emit(QiblaError(failure.message)),
    );
  }
}

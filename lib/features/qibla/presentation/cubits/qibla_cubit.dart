import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_direction_use_case.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla_state.dart';

import 'package:sana/features/qibla/domain/repositories/qibla_repository.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    required GetQiblaDirectionUseCase getQiblaDirectionUseCase,
    required GetQiblaCompassStreamUseCase getQiblaCompassStreamUseCase,
    required QiblaRepository repository,
  }) : _getQiblaDirectionUseCase = getQiblaDirectionUseCase,
       _getQiblaCompassStreamUseCase = getQiblaCompassStreamUseCase,
       _repository = repository,
       super(const QiblaInitial());

  final GetQiblaDirectionUseCase _getQiblaDirectionUseCase;
  final GetQiblaCompassStreamUseCase _getQiblaCompassStreamUseCase;
  final QiblaRepository _repository;

  void initQibla() {
    emit(const QiblaLoading());
    final result = _getQiblaDirectionUseCase();
    switch (result) {
      case Success(data: final direction):
        emit(
          QiblaSuccess(
            qiblaDirection: direction.qiblaDirection,
            distanceToKaaba: direction.distanceToKaaba,
            userLocation: direction.userLocation,
            qiblaMode: _getInitialMode(),
          ),
        );
      case FailureResult(:final failure):
        emit(QiblaError(failure.message));
    }
  }

  Stream<QiblaCompassDataEntity>? getQiblaStream(double qiblaDirection) {
    if (kIsWeb) return null;
    return _getQiblaCompassStreamUseCase(qiblaDirection: qiblaDirection);
  }

  QiblaMode _getInitialMode() {
    if (kIsWeb) return QiblaMode.map;
    final savedMode = _repository.getQiblaMode();
    return savedMode == 'map' ? QiblaMode.map : QiblaMode.compass;
  }

  void toggleMode() {
    if (state is QiblaSuccess) {
      final currentState = state as QiblaSuccess;
      if (kIsWeb) return; // Prevent toggle on web

      final newMode = currentState.qiblaMode == QiblaMode.compass
          ? QiblaMode.map
          : QiblaMode.compass;

      unawaited(
        _repository.saveQiblaMode(newMode.name),
      );
      emit(currentState.copyWith(qiblaMode: newMode));
    }
  }
}

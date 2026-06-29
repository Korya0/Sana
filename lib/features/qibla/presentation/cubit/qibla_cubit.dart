import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entities.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_compass_stream_use_case.dart';
import 'package:sana/features/qibla/domain/use_cases/get_qibla_direction_use_case.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';

class QiblaCubit extends Cubit<QiblaState> {
  QiblaCubit({
    required GetQiblaDirectionUseCase getQiblaDirectionUseCase,
    required GetQiblaCompassStreamUseCase getQiblaCompassStreamUseCase,
    required ILocalStorageService localStorageService,
  }) : _getQiblaDirectionUseCase = getQiblaDirectionUseCase,
       _getQiblaCompassStreamUseCase = getQiblaCompassStreamUseCase,
       _localStorageService = localStorageService,
       super(const QiblaInitial());

  final GetQiblaDirectionUseCase _getQiblaDirectionUseCase;
  final GetQiblaCompassStreamUseCase _getQiblaCompassStreamUseCase;
  final ILocalStorageService _localStorageService;

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
      case ApiFailure(:final failure):
        emit(QiblaError(failure.message));
    }
  }

  Stream<QiblaCompassDataEntity>? getQiblaStream(double qiblaDirection) {
    if (kIsWeb) return null;
    final stream = FlutterCompass.events;
    if (stream == null) return null;

    return _getQiblaCompassStreamUseCase(
      headingStream: stream.map((event) => event.heading ?? 0),
      qiblaDirection: qiblaDirection,
    );
  }

  QiblaMode _getInitialMode() {
    if (kIsWeb) return QiblaMode.map;
    final savedMode = _localStorageService.getString(StorageKeys.qiblaMode);
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
        _localStorageService.setString(StorageKeys.qiblaMode, newMode.name),
      );
      emit(currentState.copyWith(qiblaMode: newMode));
    }
  }
}

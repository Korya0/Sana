import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/location_manager/data/repos/i_location_repository.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_position/location_position_state.dart';

/// Manages location position operations: saving, retrieving, and storing
/// manual positions.
class LocationPositionCubit extends Cubit<LocationPositionState> {
  LocationPositionCubit({
    required ILocationRepository repository,
  })  : _repository = repository,
        super(const LocationPositionInitial());

  final ILocationRepository _repository;

  bool hasStoredLocation() => _repository.hasStoredLocation();
  String? getStoredLocationName() => _repository.getStoredLocationName();

  /// Saves the current device position and emits success/failure.
  Future<void> saveCurrentPosition() async {
    emit(const LocationPositionLoading());
    final result = await _repository.saveCurrentPosition();
    switch (result) {
      case Success():
        emit(const LocationPositionSaved());
      case FailureResult(:final failure):
        emit(LocationPositionError(message: failure.message));
    }
  }

  /// Saves a manually entered position (lat/lng + name).
  Future<void> saveManualPosition({
    required double lat,
    required double lng,
    required String name,
  }) async {
    emit(const LocationPositionLoading());
    final result = await _repository.saveManualPosition(
      lat: lat,
      lng: lng,
      name: name,
    );
    switch (result) {
      case Success():
        emit(const LocationPositionSaved());
      case FailureResult(:final failure):
        emit(LocationPositionError(message: failure.message));
    }
  }
}

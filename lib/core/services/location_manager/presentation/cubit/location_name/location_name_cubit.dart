import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/location_manager/data/repos/i_location_repository.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_name/location_name_state.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location_manager/presentation/cubit/location_permission/location_state.dart';
import 'package:sana/core/utils/utils.dart';

class LocationNameCubit extends Cubit<LocationNameState> {
  LocationNameCubit({
    required this.repository,
    required this.prefs,
    required this.locationCubit,
  }) : super(const LocationNameInitial()) {
    _listenToLocationUpdates();
    unawaited(loadLocation(locale: AppConstants.ar));
  }

  final ILocationRepository repository;
  final ILocalStorageService prefs;
  final LocationCubit locationCubit;
  StreamSubscription<LocationState>? _locationSubscription;

  void _listenToLocationUpdates() {
    _locationSubscription = locationCubit.stream.listen((locationState) {
      if (locationState is LocationSuccess) {
        unawaited(loadLocation(locale: AppConstants.ar));
      }
    });
  }

  @override
  Future<void> close() async {
    await _locationSubscription?.cancel();
    return super.close();
  }

  Future<void> loadLocation({required String locale}) async {
    if (state is LocationNameLoading) return;

    try {
      final lat = prefs.getDouble(StorageKeys.latitude);
      final lng = prefs.getDouble(StorageKeys.longitude);

      if (lat != null && lng != null) {
        final currentState = state;
        if (currentState is LocationNameLoaded &&
            currentState.lat == lat &&
            currentState.lng == lng) {
          return;
        }

        emit(const LocationNameLoading());

        final result = await repository.getCityAndCountry(
          lat: lat,
          lng: lng,
          locale: locale,
        );

        switch (result) {
          case Success(:final data):
            emit(LocationNameLoaded(data, lat: lat, lng: lng));
          case FailureResult(:final failure):
            emit(LocationNameError(failure.message));
        }
      } else {
        emit(const LocationNameError(AppStrings.waitingForLocation));
      }
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'LoadLocation Hub Error',
          error: e,
          stackTrace: stack,
        ),
      );
      emit(const LocationNameError(AppStrings.locationNameFetchError));
    }
  }
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/local_storage/local_storage_service.dart';
import 'package:sana/core/services/local_storage/storage_keys.dart';
import 'package:sana/core/services/location_manager/data/repositories/location_repository.dart';
import 'package:sana/core/services/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/core/utils/app_logger.dart';

part 'location_name_cubit.freezed.dart';
part 'location_name_state.dart';

class LocationNameCubit extends Cubit<LocationNameState> {
  LocationNameCubit({
    required this.repository,
    required this.prefs,
    required this.locationCubit,
  }) : super(const LocationNameState.initial()) {
    _listenToLocationUpdates();
    unawaited(loadLocation(locale: AppConstants.locale));
  }

  final ILocationRepository repository;
  final ILocalStorageService prefs;
  final LocationCubit locationCubit;
  StreamSubscription<LocationState>? _locationSubscription;

  void _listenToLocationUpdates() {
    _locationSubscription = locationCubit.stream.listen((locationState) {
      locationState.maybeWhen(
        success: (_) => unawaited(loadLocation(locale: AppConstants.locale)),
        orElse: () {},
      );
    });
  }

  @override
  Future<void> close() async {
    await _locationSubscription?.cancel();
    return super.close();
  }

  Future<void> loadLocation({required String locale}) async {
    if (state is LocationNameLoading) return;

    emit(const LocationNameState.loading());

    try {
      var lat = prefs.getDouble(StorageKeys.latitude);
      var lng = prefs.getDouble(StorageKeys.longitude);

      if (lat == null || lng == null) {
        // Wait a bit and check again, maybe the LocationCubit is just about to save them
        await Future<void>.delayed(const Duration(milliseconds: 500));
        lat = prefs.getDouble(StorageKeys.latitude);
        lng = prefs.getDouble(StorageKeys.longitude);
      }

      if (lat != null && lng != null) {
        final result = await repository.getCityAndCountry(
          lat: lat,
          lng: lng,
          locale: locale,
        );

        result.when(
          success: (locationName) =>
              emit(LocationNameState.loaded(locationName)),
          failure: (failure) => emit(LocationNameState.error(failure.message)),
        );
      } else {
        emit(const LocationNameState.error(AppStrings.waitingForLocation));
      }
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error('LoadLocation Hub Error', error: e, stackTrace: stack),
      );
      emit(LocationNameState.error(e.toString()));
    }
  }
}

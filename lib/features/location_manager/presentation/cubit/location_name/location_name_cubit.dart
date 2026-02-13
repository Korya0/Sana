import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/location_manager/data/location_name_service.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_name/location_name_state.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_cubit.dart';
import 'package:sana/features/location_manager/presentation/cubit/location_permission/location_state.dart';

class LocationNameCubit extends Cubit<LocationNameState> {
  final LocationNameService service;
  final SharedPref prefs;
  final LocationCubit locationCubit;
  StreamSubscription? _locationSubscription;

  LocationNameCubit({
    required this.service,
    required this.prefs,
    required this.locationCubit,
  }) : super(LocationNameInitial()) {
    _listenToLocationUpdates();
  }

  void _listenToLocationUpdates() {
    _locationSubscription = locationCubit.stream.listen((locationState) {
      if (locationState is LocationSuccess) {
        // Location updated successfully, reload name
        loadLocation(locale: AppConstants.locale); // Using default app locale
      }
    });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  Future<void> loadLocation({required String locale}) async {
    // If already loading or loaded, we might want to skip or force.
    // For now, let's just make it more robust.
    if (state is LocationNameLoading) return;

    emit(LocationNameLoading());

    try {
      double? lat = prefs.getDouble(PrefKeys.latitude);
      double? lng = prefs.getDouble(PrefKeys.longitude);

      // If coordinates are missing, try to get them from LocationCubit's current state if possible
      // but usually the stream listener handles this.
      // The issue is on first boot where prefs are empty.

      if (lat == null || lng == null) {
        // Wait a bit and check again, maybe the LocationCubit is just about to save them
        await Future.delayed(const Duration(milliseconds: 500));
        lat = prefs.getDouble(PrefKeys.latitude);
        lng = prefs.getDouble(PrefKeys.longitude);
      }

      if (lat != null && lng != null) {
        final locationName = await service.getCityAndCountry(
          lat: lat,
          lng: lng,
          locale: locale,
        );
        emit(LocationNameLoaded(locationName));
      } else {
        // If still null, we stay in error state but don't give up -
        // the stream listener will trigger this again once LocationProvider succeeds
        emit(const LocationNameError('بانتظار تحديد الموقع...'));
      }
    } catch (e) {
      emit(LocationNameError(e.toString()));
    }
  }
}

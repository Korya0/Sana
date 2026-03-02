import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';
import 'package:sana/features/location_manager/data/repositories/location_repository.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';

part 'location_name_state.dart';

class LocationNameCubit extends Cubit<LocationNameState> {
  LocationNameCubit({
    required this.repository,
    required this.prefs,
    required this.locationCubit,
  }) : super(LocationNameInitial()) {
    _listenToLocationUpdates();
    unawaited(loadLocation(locale: AppConstants.locale));
  }

  final ILocationRepository repository;
  final SharedPref prefs;
  final LocationCubit locationCubit;
  StreamSubscription<LocationState>? _locationSubscription;

  void _listenToLocationUpdates() {
    _locationSubscription = locationCubit.stream.listen((locationState) {
      if (locationState is LocationSuccess) {
        // Location updated successfully, reload name
        unawaited(loadLocation(locale: AppConstants.locale));
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

    emit(LocationNameLoading());

    try {
      var lat = prefs.getDouble(PrefKeys.latitude);
      var lng = prefs.getDouble(PrefKeys.longitude);

      if (lat == null || lng == null) {
        // Wait a bit and check again, maybe the LocationCubit is just about to save them
        await Future<void>.delayed(const Duration(milliseconds: 500));
        lat = prefs.getDouble(PrefKeys.latitude);
        lng = prefs.getDouble(PrefKeys.longitude);
      }

      if (lat != null && lng != null) {
        final result = await repository.getCityAndCountry(
          lat: lat,
          lng: lng,
          locale: locale,
        );

        result.fold(
          (failure) => emit(LocationNameError(failure.message)),
          (locationName) => emit(LocationNameLoaded(locationName)),
        );
      } else {
        emit(const LocationNameError(AppStrings.waitingForLocation));
      }
    } on Exception catch (e) {
      emit(LocationNameError(e.toString()));
    }
  }
}

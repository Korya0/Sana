import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/appstrings.dart';
import 'package:sana/core/services/location/controller/location_name/location_name_state.dart';
import 'package:sana/core/services/location/data/location_name_service.dart';
import 'package:sana/core/services/sharedpref/pref_keys.dart';
import 'package:sana/core/services/sharedpref/shared_pref.dart';

class LocationNameCubit extends Cubit<LocationNameState> {
  final LocationNameService service;
  final SharedPref prefs;

  LocationNameCubit({required this.service, required this.prefs})
    : super(LocationNameInitial());

  Future<void> loadLocation({required String locale}) async {
    emit(LocationNameLoading());

    final lat = prefs.getDouble(PrefKeys.latitude);
    final lng = prefs.getDouble(PrefKeys.longitude);

    if (lat == null || lng == null) {
      emit(const LocationNameError(Appstrings.unknownLocation));
      return;
    }

    try {
      final location = await service.getCityAndCountry(
        lat: lat,
        lng: lng,
        locale: locale,
      );
      emit(LocationNameLoaded(location));
    } catch (_) {
      emit(const LocationNameError(Appstrings.unknownLocation));
    }
  }
}

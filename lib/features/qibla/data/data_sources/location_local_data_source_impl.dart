import 'package:sana/core/error/result.dart';
import 'package:sana/core/services/location/location_service.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  LocationLocalDataSourceImpl(this._locationService);

  final LocationService _locationService;

  // Current location
  @override
  Future<LocationModel> getCurrentLocation() async {
    final result = await _locationService.getCurrentLocation();
    return switch (result) {
      Success(:final data) => LocationModel(
          latitude: data.latitude,
          longitude: data.longitude,
          heading: data.heading,
        ),
      FailureResult(:final failure) => throw failure,
    };
  }

  // Location stream
  @override
  Stream<LocationModel> onLocationChanged() =>
      _locationService.watchLocation().map(
            (result) => LocationModel(
              latitude: result.latitude,
              longitude: result.longitude,
              heading: result.heading,
            ),
          );
}

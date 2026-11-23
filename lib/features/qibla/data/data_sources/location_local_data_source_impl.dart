import 'package:geolocator/geolocator.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/features/qibla/data/data_sources/location_local_data_source.dart';
import 'package:sana/features/qibla/data/models/location_model.dart';

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  LocationLocalDataSourceImpl();

  // Current location
  @override
  Future<LocationModel> getCurrentLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw const LocationFailure(message: AppStrings.qiblaFailedTitle);
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: AppConstants.qiblaLocationTimeout12s,
      ),
    );

    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      heading: position.heading,
    );
  }

  // Location stream
  @override
  Stream<LocationModel> onLocationChanged() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: AppConstants.qiblaLocationDistanceFilter10m,
      ),
    ).map((position) {
      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        heading: position.heading,
      );
    });
  }
}

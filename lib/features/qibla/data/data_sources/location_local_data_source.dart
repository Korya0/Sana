import 'package:sana/features/qibla/data/models/location_model.dart';

abstract interface class LocationLocalDataSource {
  // Current location
  Future<LocationModel> getCurrentLocation();

  // Location stream
  Stream<LocationModel> onLocationChanged();
}

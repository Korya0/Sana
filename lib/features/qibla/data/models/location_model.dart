import 'package:sana/core/constants/app_map_keys.dart';
import 'package:sana/features/qibla/domain/entities/qibla_entity.dart';

class LocationModel extends QiblaLocation {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    this.heading,
  });

  // Phone heading
  final double? heading;

  // Parses from map
  factory LocationModel.fromMap(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json[AppMapKeys.latitude] as double,
      longitude: json[AppMapKeys.longitude] as double,
      heading: json[AppMapKeys.heading] as double?,
    );
  }

  // Converts to map
  @override
  Map<String, dynamic> toMap() {
    return {
      AppMapKeys.latitude: latitude,
      AppMapKeys.longitude: longitude,
      AppMapKeys.heading: heading,
    };
  }
}

class QiblaModel extends QiblaEntity {
  const QiblaModel({
    required super.direction,
    required super.distanceKm,
    required super.location,
    super.phoneHeading,
  });

  // Parses from map
  factory QiblaModel.fromMap(Map<String, dynamic> json) {
    return QiblaModel(
      direction: json[AppMapKeys.direction] as double,
      distanceKm: json[AppMapKeys.distanceKm] as double,
      location: LocationModel.fromMap(json[AppMapKeys.location] as Map<String, dynamic>),
      phoneHeading: json[AppMapKeys.phoneHeading] as double?,
    );
  }

  // Converts to map
  Map<String, dynamic> toMap() {
    return {
      AppMapKeys.direction: direction,
      AppMapKeys.distanceKm: distanceKm,
      AppMapKeys.location: location.toMap(),
      AppMapKeys.phoneHeading: phoneHeading,
    };
  }
}

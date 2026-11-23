import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_map_keys.dart';

class QiblaEntity {
  const QiblaEntity({
    required this.direction,
    required this.distanceKm,
    required this.location,
    this.phoneHeading,
    this.tilt = 0.0,
    this.isLowAccuracy = false,
  });

  // Qibla direction
  final double direction;

  // Distance to Kaaba
  final double distanceKm;

  // User coordinates
  final QiblaLocation location;

  // Phone heading
  final double? phoneHeading;

  // Phone tilt
  final double tilt;

  // Low accuracy
  final bool isLowAccuracy;

  // Angle difference
  double get angleDifference {
    if (phoneHeading == null) return 0.0;
    final diff = direction - phoneHeading!;
    return ((diff % 360) + 540) % 360 - 180;
  }

  // Remaining degrees
  int get remainingDegrees => angleDifference.abs().round();

  // Not flat
  bool get isNotFlat => tilt > AppConstants.qiblaTiltTolerance;

  // Facing state
  bool get isFacing =>
      phoneHeading != null &&
      !isNotFlat &&
      !isLowAccuracy &&
      angleDifference.abs() <= AppConstants.qiblaFacingTolerance;

  // Copies entity
  QiblaEntity copyWith({
    double? direction,
    double? distanceKm,
    QiblaLocation? location,
    double? phoneHeading,
    double? tilt,
    bool? isLowAccuracy,
  }) => QiblaEntity(
    direction: direction ?? this.direction,
    distanceKm: distanceKm ?? this.distanceKm,
    location: location ?? this.location,
    phoneHeading: phoneHeading ?? this.phoneHeading,
    tilt: tilt ?? this.tilt,
    isLowAccuracy: isLowAccuracy ?? this.isLowAccuracy,
  );

  // Compares entities
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QiblaEntity &&
          direction == other.direction &&
          distanceKm == other.distanceKm &&
          location == other.location &&
          phoneHeading == other.phoneHeading &&
          tilt == other.tilt &&
          isLowAccuracy == other.isLowAccuracy;

  // Hashes entity
  @override
  int get hashCode => Object.hash(
    direction,
    distanceKm,
    location,
    phoneHeading,
    tilt,
    isLowAccuracy,
  );
}

class QiblaLocation {
  const QiblaLocation({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  // Copies location
  QiblaLocation copyWith({double? latitude, double? longitude}) =>
      QiblaLocation(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  // Converts to map
  Map<String, dynamic> toMap() => {
    AppMapKeys.latitude: latitude,
    AppMapKeys.longitude: longitude,
  };

  // Compares locations
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QiblaLocation &&
          latitude == other.latitude &&
          longitude == other.longitude;

  // Hashes location
  @override
  int get hashCode => Object.hash(latitude, longitude);
}

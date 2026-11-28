class LocationResult {
  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.heading,
    required this.takenAt,
  });

  final double latitude;
  final double longitude;
  final double? heading;
  final DateTime takenAt;
}

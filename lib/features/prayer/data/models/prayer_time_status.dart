/// Represents the spiritual status of the current time
/// (e.g., prohibited time, Dhuha, between Azan and Iqama, etc.)
class PrayerTimeStatus {
  const PrayerTimeStatus({
    required this.id,
    required this.status,
    required this.description,
    this.source,
  });

  factory PrayerTimeStatus.fromJson(Map<String, dynamic> json) {
    return PrayerTimeStatus(
      id: json['id'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      source: json['source'] as String?,
    );
  }

  final String id;
  final String status;
  final String description;
  final String? source;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'description': description,
      'source': source,
    };
  }
}

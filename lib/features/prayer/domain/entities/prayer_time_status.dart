import 'package:flutter/foundation.dart';

@immutable
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

  PrayerTimeStatus copyWith({
    String? id,
    String? status,
    String? description,
    String? source,
  }) {
    return PrayerTimeStatus(
      id: id ?? this.id,
      status: status ?? this.status,
      description: description ?? this.description,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PrayerTimeStatus) return false;
    return id == other.id &&
        status == other.status &&
        description == other.description &&
        source == other.source;
  }

  @override
  int get hashCode =>
      id.hashCode ^ status.hashCode ^ description.hashCode ^ source.hashCode;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_time_status.freezed.dart';
part 'prayer_time_status.g.dart';

/// Represents the spiritual status of the current time
/// (e.g., prohibited time, Dhuha, between Azan and Iqama, etc.)
@freezed
class PrayerTimeStatus with _$PrayerTimeStatus {
  const factory PrayerTimeStatus({
    required String id,
    required String status,
    required String description,
    String? source,
  }) = _PrayerTimeStatus;

  factory PrayerTimeStatus.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimeStatusFromJson(json);
}

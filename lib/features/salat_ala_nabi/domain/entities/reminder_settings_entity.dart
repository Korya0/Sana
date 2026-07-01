import 'package:flutter/foundation.dart';

@immutable
class ReminderSettingsEntity {
  const ReminderSettingsEntity({
    required this.isEnabled,
    required this.intervalMinutes,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.workingHoursMode,
  });

  final bool isEnabled;
  final int intervalMinutes;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final int workingHoursMode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReminderSettingsEntity &&
        other.isEnabled == isEnabled &&
        other.intervalMinutes == intervalMinutes &&
        other.startHour == startHour &&
        other.startMinute == startMinute &&
        other.endHour == endHour &&
        other.endMinute == endMinute &&
        other.workingHoursMode == workingHoursMode;
  }

  @override
  int get hashCode =>
      isEnabled.hashCode ^
      intervalMinutes.hashCode ^
      startHour.hashCode ^
      startMinute.hashCode ^
      endHour.hashCode ^
      endMinute.hashCode ^
      workingHoursMode.hashCode;
}

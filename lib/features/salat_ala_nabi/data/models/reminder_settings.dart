import 'package:flutter/foundation.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';

@immutable
class ReminderSettingsModel {
  const ReminderSettingsModel({
    required this.isEnabled,
    required this.intervalMinutes,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.workingHoursMode,
  });

  factory ReminderSettingsModel.defaultSettings() {
    return const ReminderSettingsModel(
      isEnabled: false,
      intervalMinutes: 15,
      startHour: 0,
      startMinute: 0,
      endHour: 23,
      endMinute: 59,
      workingHoursMode: 0,
    );
  }

  factory ReminderSettingsModel.fromJson(Map<String, dynamic> json) {
    return ReminderSettingsModel(
      isEnabled: json[AppSalawatConstants.keyIsEnabled] as bool? ?? false,
      intervalMinutes:
          json[AppSalawatConstants.keyIntervalMinutes] as int? ?? 15,
      startHour: json[AppSalawatConstants.keyStartHour] as int? ?? 0,
      startMinute: json[AppSalawatConstants.keyStartMinute] as int? ?? 0,
      endHour: json[AppSalawatConstants.keyEndHour] as int? ?? 23,
      endMinute: json[AppSalawatConstants.keyEndMinute] as int? ?? 59,
      workingHoursMode:
          json[AppSalawatConstants.keyWorkingHoursMode] as int? ?? 0,
    );
  }
  final bool isEnabled;
  final int intervalMinutes;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final int workingHoursMode;

  ReminderSettingsModel copyWith({
    bool? isEnabled,
    int? intervalMinutes,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    int? workingHoursMode,
  }) {
    return ReminderSettingsModel(
      isEnabled: isEnabled ?? this.isEnabled,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      workingHoursMode: workingHoursMode ?? this.workingHoursMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AppSalawatConstants.keyIsEnabled: isEnabled,
      AppSalawatConstants.keyIntervalMinutes: intervalMinutes,
      AppSalawatConstants.keyStartHour: startHour,
      AppSalawatConstants.keyStartMinute: startMinute,
      AppSalawatConstants.keyEndHour: endHour,
      AppSalawatConstants.keyEndMinute: endMinute,
      AppSalawatConstants.keyWorkingHoursMode: workingHoursMode,
    };
  }

  bool isWithinWorkingHours(DateTime time) {
    final currentInMinutes = time.hour * 60 + time.minute;
    final startInMinutes = startHour * 60 + startMinute;
    final endInMinutes = endHour * 60 + endMinute;

    if (startInMinutes <= endInMinutes) {
      return currentInMinutes >= startInMinutes &&
          currentInMinutes <= endInMinutes;
    } else {
      // Case where the range crosses midnight (e.g., 22:00 to 02:00)
      return currentInMinutes >= startInMinutes ||
          currentInMinutes <= endInMinutes;
    }
  }

  String _formatTime(int hour, int minute) {
    final hourOfPeriod = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    final period = hour < 12 ? AppStrings.am : AppStrings.pm;
    return '$hourOfPeriod:$minuteStr $period';
  }

  String get formattedStartTime => _formatTime(startHour, startMinute);
  String get formattedEndTime => _formatTime(endHour, endMinute);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderSettingsModel &&
          runtimeType == other.runtimeType &&
          isEnabled == other.isEnabled &&
          intervalMinutes == other.intervalMinutes &&
          startHour == other.startHour &&
          startMinute == other.startMinute &&
          endHour == other.endHour &&
          endMinute == other.endMinute &&
          workingHoursMode == other.workingHoursMode;

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

import 'package:flutter/foundation.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/domain/entities/reminder_settings_entity.dart';

@immutable
class ReminderSettingsModel extends ReminderSettingsEntity {
  const ReminderSettingsModel({
    required super.isEnabled,
    required super.intervalMinutes,
    required super.startHour,
    required super.startMinute,
    required super.endHour,
    required super.endMinute,
    required super.workingHoursMode,
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

  factory ReminderSettingsModel.fromEntity(ReminderSettingsEntity entity) {
    return ReminderSettingsModel(
      isEnabled: entity.isEnabled,
      intervalMinutes: entity.intervalMinutes,
      startHour: entity.startHour,
      startMinute: entity.startMinute,
      endHour: entity.endHour,
      endMinute: entity.endMinute,
      workingHoursMode: entity.workingHoursMode,
    );
  }

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
}

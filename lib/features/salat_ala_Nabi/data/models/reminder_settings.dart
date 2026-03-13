import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_settings.freezed.dart';
part 'reminder_settings.g.dart';

@freezed
class ReminderSettings with _$ReminderSettings {
  const factory ReminderSettings({
    required bool isEnabled,
    required int intervalMinutes,
    required int startHour,
    required int startMinute,
    required int endHour,
    required int endMinute,
    required int workingHoursMode,
  }) = _ReminderSettings;

  factory ReminderSettings.defaultSettings() {
    return const ReminderSettings(
      isEnabled: false,
      intervalMinutes: 15,
      startHour: 0,
      startMinute: 0,
      endHour: 23,
      endMinute: 59,
      workingHoursMode: 0,
    );
  }

  factory ReminderSettings.fromJson(Map<String, dynamic> json) =>
      _$ReminderSettingsFromJson(json);
}

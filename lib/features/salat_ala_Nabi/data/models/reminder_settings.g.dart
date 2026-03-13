// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderSettingsImpl _$$ReminderSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$ReminderSettingsImpl(
  isEnabled: json['isEnabled'] as bool,
  intervalMinutes: (json['intervalMinutes'] as num).toInt(),
  startHour: (json['startHour'] as num).toInt(),
  startMinute: (json['startMinute'] as num).toInt(),
  endHour: (json['endHour'] as num).toInt(),
  endMinute: (json['endMinute'] as num).toInt(),
  workingHoursMode: (json['workingHoursMode'] as num).toInt(),
);

Map<String, dynamic> _$$ReminderSettingsImplToJson(
  _$ReminderSettingsImpl instance,
) => <String, dynamic>{
  'isEnabled': instance.isEnabled,
  'intervalMinutes': instance.intervalMinutes,
  'startHour': instance.startHour,
  'startMinute': instance.startMinute,
  'endHour': instance.endHour,
  'endMinute': instance.endMinute,
  'workingHoursMode': instance.workingHoursMode,
};

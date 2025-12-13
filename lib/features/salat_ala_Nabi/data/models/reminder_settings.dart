import 'package:equatable/equatable.dart';

class ReminderSettings extends Equatable {
  final bool isEnabled;
  final int intervalMinutes;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final int workingHoursMode;

  const ReminderSettings({
    required this.isEnabled,
    required this.intervalMinutes,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.workingHoursMode,
  });

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

  ReminderSettings copyWith({
    bool? isEnabled,
    int? intervalMinutes,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    int? workingHoursMode,
  }) {
    return ReminderSettings(
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
      'isEnabled': isEnabled,
      'intervalMinutes': intervalMinutes,
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
      'workingHoursMode': workingHoursMode,
    };
  }

  factory ReminderSettings.fromJson(Map<String, dynamic> json) {
    return ReminderSettings(
      isEnabled: json['isEnabled'] as bool,
      intervalMinutes: json['intervalMinutes'] as int,
      startHour: json['startHour'] as int,
      startMinute: json['startMinute'] as int,
      endHour: json['endHour'] as int,
      endMinute: json['endMinute'] as int,
      workingHoursMode: json['workingHoursMode'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    isEnabled,
    intervalMinutes,
    startHour,
    startMinute,
    endHour,
    endMinute,
    workingHoursMode,
  ];
}

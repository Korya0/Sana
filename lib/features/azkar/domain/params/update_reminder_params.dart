import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

@immutable
class UpdateReminderParams {
  const UpdateReminderParams({
    required this.id,
    required this.time,
    required this.repeatType,
    required this.days,
    required this.isEnabled,
    required this.timezone,
    required this.template,
  });

  final String id;
  final String time;
  final RepeatType repeatType;
  final List<int> days;
  final bool isEnabled;
  final String timezone;
  final NotificationTemplate template;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateReminderParams &&
        other.id == id &&
        other.time == time &&
        other.repeatType == repeatType &&
        listEquals(other.days, days) &&
        other.isEnabled == isEnabled &&
        other.timezone == timezone &&
        other.template == template;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      time.hashCode ^
      repeatType.hashCode ^
      Object.hashAll(days) ^
      isEnabled.hashCode ^
      timezone.hashCode ^
      template.hashCode;
}

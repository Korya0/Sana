import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

@immutable
class CreateReminderParams {
  const CreateReminderParams({
    required this.azkarId,
    required this.time,
    required this.repeatType,
    required this.days,
    required this.isEnabled,
    required this.timezone,
    required this.template,
  });

  final String azkarId;
  final String time;
  final RepeatType repeatType;
  final List<int> days;
  final bool isEnabled;
  final String timezone;
  final NotificationTemplate template;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateReminderParams &&
        other.azkarId == azkarId &&
        other.time == time &&
        other.repeatType == repeatType &&
        listEquals(other.days, days) &&
        other.isEnabled == isEnabled &&
        other.timezone == timezone &&
        other.template == template;
  }

  @override
  int get hashCode =>
      azkarId.hashCode ^
      time.hashCode ^
      repeatType.hashCode ^
      Object.hashAll(days) ^
      isEnabled.hashCode ^
      timezone.hashCode ^
      template.hashCode;
}

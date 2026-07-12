import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

/// Allowed Azkar category IDs that support reminders.
/// Only Morning (2), Evening (3), Sleep (4), and Wake up (5) are supported.
const List<String> allowedReminderCategoryIds = ['2', '3', '4', '5'];

@immutable
class ReminderEntity {
  const ReminderEntity({
    required this.id,
    required this.azkarId,
    required this.time,
    required this.repeatType,
    required this.days,
    required this.isEnabled,
    required this.timezone,
    required this.template,
  });

  final String id;
  final String azkarId;
  final String time; // Format: "HH:mm"
  final RepeatType repeatType;
  final List<int> days; // 1 = Monday, 7 = Sunday
  final bool isEnabled;
  final String timezone;
  final NotificationTemplate template;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReminderEntity &&
        other.id == id &&
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
      id.hashCode ^
      azkarId.hashCode ^
      time.hashCode ^
      repeatType.hashCode ^
      Object.hashAll(days) ^
      isEnabled.hashCode ^
      timezone.hashCode ^
      template.hashCode;

  ReminderEntity copyWith({
    String? id,
    String? azkarId,
    String? time,
    RepeatType? repeatType,
    List<int>? days,
    bool? isEnabled,
    String? timezone,
    NotificationTemplate? template,
  }) {
    return ReminderEntity(
      id: id ?? this.id,
      azkarId: azkarId ?? this.azkarId,
      time: time ?? this.time,
      repeatType: repeatType ?? this.repeatType,
      days: days ?? this.days,
      isEnabled: isEnabled ?? this.isEnabled,
      timezone: timezone ?? this.timezone,
      template: template ?? this.template,
    );
  }

  int get hour {
    if (time.isEmpty || !time.contains(':')) return 0;
    return int.tryParse(time.split(':')[0]) ?? 0;
  }

  int get minute {
    if (time.isEmpty || !time.contains(':')) return 0;
    return int.tryParse(time.split(':')[1]) ?? 0;
  }
}

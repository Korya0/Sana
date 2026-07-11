import 'package:sana/core/services/notification/models/notification_payload.dart';

class NotificationRequest {
  const NotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDateTime,
    required this.payload,
    this.repeats = false,
    this.weekdays,
    this.channelId,
    this.channelName,
    this.channelDescription,
    this.soundFileName,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledDateTime;
  final NotificationPayload payload;
  final bool repeats;
  final List<int>? weekdays; // 1 = Monday, 7 = Sunday (standard DateTime/ISO)
  final String? channelId;
  final String? channelName;
  final String? channelDescription;
  final String? soundFileName;
}

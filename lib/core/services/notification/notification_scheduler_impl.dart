import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/notification/models/notification_request.dart';
import 'package:sana/core/services/notification/notification_keys.dart';
import 'package:sana/core/services/notification/notification_scheduler.dart';

class NotificationSchedulerImpl implements INotificationScheduler {
  const NotificationSchedulerImpl(this._notificationService);

  final INotificationService _notificationService;

  @override
  Future<void> schedule(NotificationRequest request) async {
    await _notificationService.zonedSchedule(
      id: request.id,
      title: request.title,
      body: request.body,
      scheduledDateTime: request.scheduledDateTime,
      channelId: request.channelId,
      channelName: request.channelName,
      channelDescription: request.channelDescription,
      soundFileName: request.soundFileName,
      payload: request.payload.toRawJson(),
      matchDateTimeComponents: request.repeats
          ? NotificationKeys.matchDayOfWeekAndTime
          : null,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await _notificationService.cancel(id);
  }

  @override
  Future<void> cancelAll() async {
    await _notificationService.cancelAll();
  }
}

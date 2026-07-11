import 'package:sana/core/services/notification/models/notification_request.dart';

abstract interface class NotificationScheduler {
  Future<void> schedule(NotificationRequest request);
  Future<void> cancel(int id);
  Future<void> cancelAll();
}

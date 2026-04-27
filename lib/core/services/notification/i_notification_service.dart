abstract interface class INotificationService {
  Future<void> initialize();
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? channelId,
    String? channelName,
    String? channelDescription,
    String? soundFileName,
  });
  Future<void> cancelAll();
  Future<void> cancel(int id);
}

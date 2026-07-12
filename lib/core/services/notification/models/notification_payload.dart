import 'dart:async';
import 'dart:convert';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/services/notification/notification_keys.dart';

class NotificationPayload {
  const NotificationPayload({
    required this.id,
    required this.type,
    this.data = const {},
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    final rawData = json[NotificationKeys.data] as Map<dynamic, dynamic>? ?? {};
    final stringData = rawData.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
    return NotificationPayload(
      id: json[NotificationKeys.id] as String? ?? '',
      type: json[NotificationKeys.type] as String? ?? '',
      data: stringData,
    );
  }

  factory NotificationPayload.fromRawJson(String rawJson) {
    try {
      final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      return NotificationPayload.fromJson(decoded);
    } on Object catch (e, stack) {
      unawaited(AppLogger.warn(
        'Failed to parse notification payload: $rawJson',
        error: e,
        stackTrace: stack,
      ));
      return const NotificationPayload(id: '', type: '');
    }
  }

  final String id;
  final String type;
  final Map<String, String> data;

  Map<String, dynamic> toJson() => {
        NotificationKeys.id: id,
        NotificationKeys.type: type,
        NotificationKeys.data: data,
      };

  String toRawJson() => jsonEncode(toJson());
}

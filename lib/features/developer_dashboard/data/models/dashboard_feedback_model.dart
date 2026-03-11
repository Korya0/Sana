import 'package:sana/features/feedback/data/constants/feedback_keys.dart';

class DashboardFeedbackModel {
  DashboardFeedbackModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.metadata,
    this.contactInfo = '',
  });

  factory DashboardFeedbackModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return DashboardFeedbackModel(
      id: id,
      message: json[FeedbackFirestoreKeys.message] as String? ?? '',
      contactInfo: json[FeedbackFirestoreKeys.contactInfo] as String? ?? '',
      timestamp: json[FeedbackFirestoreKeys.timestamp] as String? ?? '',
      metadata:
          json[FeedbackFirestoreKeys.metadata] as Map<String, dynamic>? ?? {},
    );
  }

  final String id;
  final String message;
  final String contactInfo;
  final String timestamp;
  final Map<String, dynamic> metadata;
}

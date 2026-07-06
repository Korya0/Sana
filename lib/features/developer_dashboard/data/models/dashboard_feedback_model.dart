import 'package:intl/intl.dart';
import 'package:sana/features/developer_dashboard/domain/entities/feedback_entity.dart';
import 'package:sana/features/feedback/constants/feedback_keys.dart';

class DashboardFeedbackModel extends FeedbackEntity {
  const DashboardFeedbackModel({
    required super.id,
    required super.message,
    required super.timestamp,
    required super.metadata,
    super.contactInfo,
  });

  factory DashboardFeedbackModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return DashboardFeedbackModel(
      id: id,
      message: json[FeedbackFirestoreKeys.message] as String? ?? '',
      contactInfo: json[FeedbackFirestoreKeys.contactInfo] as String?,
      timestamp: json[FeedbackFirestoreKeys.timestamp] as String? ?? '',
      metadata: json[FeedbackFirestoreKeys.metadata] != null
          ? Map<String, dynamic>.from(
              json[FeedbackFirestoreKeys.metadata] as Map,
            )
          : <String, dynamic>{},
    );
  }

  String get formattedDate {
    final date = DateTime.tryParse(timestamp);
    if (date == null) return timestamp;
    return DateFormat('dd/MM/yyyy - hh:mm a').format(date);
  }
}

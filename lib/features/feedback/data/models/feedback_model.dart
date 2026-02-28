import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/constants/firestore_keys.dart';

class FeedbackModel {
  FeedbackModel({
    required this.message,
    required this.timestamp,
    required this.metadata,
    this.contactInfo = AppStrings.notAvailable,
  });
  final String message;
  final String contactInfo;
  final String timestamp;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() {
    return {
      FeedbackFirestoreKeys.message: message,
      FeedbackFirestoreKeys.contactInfo: contactInfo,
      FeedbackFirestoreKeys.timestamp: timestamp,
      FeedbackFirestoreKeys.metadata: metadata,
    };
  }
}

import 'package:sana/features/feedback/constant/firestore_keys.dart';
import 'package:sana/features/feedback/constant/string_constant.dart';

class FeedbackModel {
  FeedbackModel({
    required this.message,
    required this.timestamp,
    required this.metadata,
    this.contactInfo = StringConstant.notAvailable,
  });
  final String message;
  final String contactInfo;
  final String timestamp;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() {
    return {
      FirestoreKeys.message: message,
      FirestoreKeys.contactInfo: contactInfo,
      FirestoreKeys.timestamp: timestamp,
      FirestoreKeys.metadata: metadata,
    };
  }
}

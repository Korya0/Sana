import 'package:sana/features/report/constant/firestore_keys.dart';
import 'package:sana/features/report/constant/string_constant.dart';

class ReportModel {
  ReportModel({
    required this.message,
    required this.isSuggestion,
    required this.type,
    required this.timestamp,
    required this.metadata,
    this.contactInfo = StringConstant.notAvailable,
    this.errorDetails = StringConstant.notFound,
  });
  final String message;
  final String contactInfo;
  final String errorDetails;
  final bool isSuggestion;
  final String type;
  final String timestamp;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() {
    return {
      FirestoreKeys.message: message,
      FirestoreKeys.contactInfo: contactInfo,
      FirestoreKeys.errorDetails: errorDetails,
      FirestoreKeys.isSuggestion: isSuggestion,
      FirestoreKeys.type: type,
      FirestoreKeys.timestamp: timestamp,
      FirestoreKeys.metadata: metadata,
    };
  }
}

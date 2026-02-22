class ReportModel {
  const ReportModel({
    required this.id,
    required this.message,
    required this.type,
    required this.isSuggestion,
    required this.timestamp,
    this.errorDetails,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json, String id) {
    return ReportModel(
      id: id,
      message: json['message'] as String? ?? 'بدون رسالة',
      type: json['type'] as String? ?? 'user',
      isSuggestion: json['isSuggestion'] as bool? ?? false,
      timestamp: json['timestamp'] as String? ?? '',
      errorDetails: json['errorDetails'] as String?,
    );
  }

  final String id;
  final String message;
  final String type; // 'user' او 'system'
  final bool isSuggestion;
  final String timestamp;
  final String? errorDetails;
}

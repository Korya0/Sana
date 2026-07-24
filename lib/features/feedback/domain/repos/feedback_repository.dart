import 'package:sana/core/network/result.dart';

abstract interface class FeedbackRepository {
  Future<Result<bool>> sendFeedback({
    required String message,
    String? contactInfo,
  });
}

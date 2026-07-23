import 'package:sana/core/network/result.dart';

abstract interface class IFeedbackRepository {
  Future<Result<bool>> sendFeedback({
    required String message,
    String? contactInfo,
  });
}

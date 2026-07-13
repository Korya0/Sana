import 'package:sana/core/networking/result.dart';

abstract interface class IFeedbackRepository {
  Future<Result<bool>> sendFeedback({
    required String message,
    String? contactInfo,
  });
}

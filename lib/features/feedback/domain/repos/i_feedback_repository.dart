import 'package:sana/core/networking/result.dart';

abstract class IFeedbackRepository {
  Future<Result<bool>> sendFeedback({
    required String message,
    String? contactInfo,
  });
}

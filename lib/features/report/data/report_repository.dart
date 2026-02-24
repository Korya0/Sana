import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';

class ReportRepository {
  ReportRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Either<Failure, bool>> sendReport({
    required String message,
    String? errorDetails,
    bool isSuggestion = false,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    final type = errorDetails != null ? 'system' : 'user';

    final safeErrorDetails = (errorDetails == null || errorDetails.isEmpty)
        ? 'لا يوجد'
        : errorDetails;

    final reportData = {
      'message': message,
      'errorDetails': safeErrorDetails,
      'isSuggestion': isSuggestion,
      'type': type,
      'timestamp': timestamp,
    };

    try {
      await _firestore.collection('reports').add(reportData);
      AppLogger.success('Report sent successfully to Firestore!');
      return const Right(true);
    } catch (e, stack) {
      AppLogger.error(
        'Error sending report to Firestore',
        error: e,
        stackTrace: stack,
      );
      return Left(
        ServerFailure(
          message: AppStrings.serverError,
          technicalMessage: 'Firestore Error: $e',
        ),
      );
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/utils/device_info_service.dart';
import 'package:sana/features/feedback/constant/firestore_keys.dart';
import 'package:sana/features/feedback/constant/string_constant.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/models/feedback_model.dart';

abstract class IFeedbackRepository {
  Future<Either<Failure, bool>> sendFeedback({
    required String message,
    String? contactInfo,
  });
}

class FeedbackRepository implements IFeedbackRepository {
  FeedbackRepository(this._remoteDataSource, this._deviceInfoService);

  final IFeedbackRemoteDataSource _remoteDataSource;
  final DeviceInfoService _deviceInfoService;

  @override
  Future<Either<Failure, bool>> sendFeedback({
    required String message,
    String? contactInfo,
  }) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final metadata = await _deviceInfoService.getDeviceInfo();

      final feedbackModel = FeedbackModel(
        message: message,
        contactInfo: contactInfo ?? StringConstant.notAvailable,
        timestamp: timestamp,
        metadata: metadata,
      );

      await _remoteDataSource.sendFeedback(feedbackModel.toJson());
      AppLogger.success('Feedback sent successfully with metadata!');
      return const Right(true);
    } catch (e, stack) {
      await AppLogger.error(
        'Error sending Feedback',
        error: e,
        stackTrace: stack,
      );

      if (e.toString().contains(FirestoreKeys.unavailable) ||
          e.toString().contains(FirestoreKeys.network) ||
          e.toString().contains(FirestoreKeys.socketException)) {
        return const Left(
          NetworkFailure(
            message: StringConstant.noInternet,
          ),
        );
      }

      return const Left(
        ServerFailure(
          message: StringConstant.serverError,
        ),
      );
    }
  }
}

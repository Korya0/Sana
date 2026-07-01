import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/feedback/constants/feedback_keys.dart';
import 'package:sana/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/models/feedback_model.dart';

abstract class IFeedbackRepository {
  Future<Result<bool>> sendFeedback({
    required String message,
    String? contactInfo,
  });
}

class FeedbackRepoImpl implements IFeedbackRepository {
  FeedbackRepoImpl(this._remoteDataSource, this._deviceInfoService);

  final IFeedbackRemoteDataSource _remoteDataSource;
  final IDeviceInfoService _deviceInfoService;

  @override
  Future<Result<bool>> sendFeedback({
    required String message,
    String? contactInfo,
  }) async {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final metadata = await _deviceInfoService.getDeviceInfo();

      final feedbackModel = FeedbackModel(
        message: message,
        contactInfo: contactInfo?.isNotEmpty == true ? contactInfo! : '',
        timestamp: timestamp,
        metadata: metadata,
      );

      // Send feedback: wait for initial response to catch immediate network/validation errors
      await _remoteDataSource.sendFeedback(feedbackModel.toJson());

      AppLogger.success('Feedback queued successfully (with offline support)');
      return const Result.success(true);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'Error queueing Feedback',
          error: e,
          stackTrace: stack,
        ),
      );

      if (e.toString().contains(FeedbackFirestoreKeys.unavailable) ||
          e.toString().contains(FeedbackFirestoreKeys.network) ||
          e.toString().contains(FeedbackFirestoreKeys.socketException)) {
        return const Result.failure(
          NetworkFailure(
            message: AppStrings.noInternet,
          ),
        );
      }

      return const Result.failure(
        ServerFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}

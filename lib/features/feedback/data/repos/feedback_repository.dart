import 'dart:async';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/device_info/device_info_service.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/feedback/data/data_sources/feedback_remote_data_source.dart';
import 'package:sana/features/feedback/data/models/feedback_model.dart';
import 'package:sana/features/feedback/domain/repos/feedback_repository.dart';

class FeedbackRepoImpl implements FeedbackRepository {
  FeedbackRepoImpl(this._remoteDataSource, this._deviceInfoService);

  final FeedbackRemoteDataSource _remoteDataSource;
  final DeviceInfoService _deviceInfoService;

  @override
  Future<Result<bool>> sendFeedback({
    required String message,
    String? contactInfo,
  }) async {
    try {
      final metadataModel = await _deviceInfoService.getDeviceInfo();
      final timestamp = DateTime.now().toIso8601String();

      final feedbackModel = FeedbackModel(
        message: message,
        contactInfo: contactInfo?.isNotEmpty == true ? contactInfo! : '',
        timestamp: timestamp,
        metadata: metadataModel.toJson(),
      );

      // Send feedback: wait for initial response to catch immediate network/validation errors
      await _remoteDataSource.sendFeedback(feedbackModel.toJson());

      AppLogger.success('Feedback queued successfully (with offline support)');
      return const Result.success(true);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error queueing Feedback',
          error: e,
          stackTrace: stack,
        ),
      );

      // Fallback for UI
      return const Result.failure(
        ServerFailure(
          message: AppStrings.ourFault,
        ),
      );
    }
  }
}

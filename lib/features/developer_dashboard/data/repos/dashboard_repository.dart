import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';

abstract class IDashboardRepository {
  Future<Result<List<DashboardFeedbackModel>>> getFeedbacks();
  Future<Result<void>> deleteFeedback(String id);
}

class DashboardRepoImpl implements IDashboardRepository {
  DashboardRepoImpl(this._remoteDataSource);

  final IDashboardRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<DashboardFeedbackModel>>> getFeedbacks() async {
    try {
      final feedbacks = await _remoteDataSource.getFeedbacks();
      return Result.success(feedbacks);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'Error fetching feedbacks',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ServerFailure(message: AppStrings.ourFault),
      );
    }
  }

  @override
  Future<Result<void>> deleteFeedback(String id) async {
    try {
      await _remoteDataSource.deleteFeedback(id);
      return const Result.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.localError(
          'Error deleting feedback',
          error: e,
          stackTrace: stack,
        ),
      );
      return const Result.failure(
        ServerFailure(message: AppStrings.ourFault),
      );
    }
  }
}

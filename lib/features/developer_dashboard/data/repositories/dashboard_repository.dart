import 'dart:async';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';

abstract class IDashboardRepository {
  Future<ApiResult<List<DashboardFeedbackModel>>> getFeedbacks();
  Future<ApiResult<void>> deleteFeedback(String id);
}

class DashboardRepository implements IDashboardRepository {
  DashboardRepository(this._remoteDataSource);

  final IDashboardRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<DashboardFeedbackModel>>> getFeedbacks() async {
    try {
      final feedbacks = await _remoteDataSource.getFeedbacks();
      return ApiResult.success(feedbacks);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error fetching feedbacks',
          error: e,
          stackTrace: stack,
        ),
      );
      return const ApiResult.failure(
        Failure.server(message: AppStrings.ourFault),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteFeedback(String id) async {
    try {
      await _remoteDataSource.deleteFeedback(id);
      return const ApiResult.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'Error deleting feedback',
          error: e,
          stackTrace: stack,
        ),
      );
      return const ApiResult.failure(
        Failure.server(message: AppStrings.ourFault),
      );
    }
  }
}

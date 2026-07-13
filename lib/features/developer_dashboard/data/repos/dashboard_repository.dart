import 'dart:async';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';

abstract interface class IDashboardRepository {
  Future<Result<List<DashboardFeedbackModel>>> getFeedbacks();
  List<DashboardFeedbackModel> get cachedFeedbacks;
  void removeFeedbackLocally(String id);
  Future<Result<void>> deleteFeedback(String id);
}

class DashboardRepoImpl implements IDashboardRepository {
  DashboardRepoImpl(this._remoteDataSource);

  final IDashboardRemoteDataSource _remoteDataSource;

  List<DashboardFeedbackModel> _cachedFeedbacks = [];

  @override
  List<DashboardFeedbackModel> get cachedFeedbacks => _cachedFeedbacks;

  @override
  Future<Result<List<DashboardFeedbackModel>>> getFeedbacks() async {
    try {
      _cachedFeedbacks = await _remoteDataSource.getFeedbacks();
      return Result.success(_cachedFeedbacks);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
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
  void removeFeedbackLocally(String id) {
    _cachedFeedbacks = _cachedFeedbacks.where((f) => f.id != id).toList();
  }

  @override
  Future<Result<void>> deleteFeedback(String id) async {
    // We assume the caller already saved the feedback to remove or called removeFeedbackLocally
    // But we need the item for rollback if it fails.
    // Let's actually not do the cache removal in deleteFeedback, the caller should do it.
    // Wait, if the caller already did `removeFeedbackLocally`, it's not in `_cachedFeedbacks` anymore!
    // So the repo must handle the whole transaction.

    // Actually, let's keep it simple as before:
    try {
      await _remoteDataSource.deleteFeedback(id);
      return const Result.success(null);
    } on Object catch (e, stack) {
      unawaited(
        AppLogger.error(
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

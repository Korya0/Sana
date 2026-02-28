import 'package:dartz/dartz.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/developer_dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';

abstract class IDashboardRepository {
  Future<Either<Failure, List<DashboardFeedbackModel>>> getFeedbacks();
  Future<Either<Failure, void>> deleteFeedback(String id);
}

class DashboardRepository implements IDashboardRepository {
  DashboardRepository(this._remoteDataSource);

  final IDashboardRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<DashboardFeedbackModel>>> getFeedbacks() async {
    try {
      final feedbacks = await _remoteDataSource.getFeedbacks();
      return Right(feedbacks);
    } catch (e, stack) {
      await AppLogger.error(
        'Error fetching feedbacks',
        error: e,
        stackTrace: stack,
      );
      return const Left(ServerFailure(message: AppStrings.serverError));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFeedback(String id) async {
    try {
      await _remoteDataSource.deleteFeedback(id);
      return const Right(null);
    } catch (e, stack) {
      await AppLogger.error(
        'Error deleting feedback',
        error: e,
        stackTrace: stack,
      );
      return const Left(ServerFailure(message: AppStrings.serverError));
    }
  }
}

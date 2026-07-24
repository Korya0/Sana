import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/developer_dashboard/data/repos/dashboard_repository.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/developer_dashboard/presentation/cubits/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardInitial());

  final DashboardRepository _repository;

  Future<void> getFeedbacks() async {
    emit(const DashboardFeedbacksLoading());
    final result = await _repository.getFeedbacks();

    switch (result) {
      case Success(data: final feedbacks):
        emit(DashboardFeedbacksLoaded(feedbacks: feedbacks));
      case FailureResult(:final failure):
        emit(DashboardFeedbacksError(message: failure.message));
    }
  }

  void deleteFeedback(String id) {
    if (state is DashboardFeedbacksLoaded) {
      // Optimistic update
      _repository.removeFeedbackLocally(id);
      final newFeedbacks = _repository.cachedFeedbacks;
      emit(DashboardFeedbacksLoaded(feedbacks: newFeedbacks));

      unawaited(
        _repository.deleteFeedback(id).then((result) async {
          if (isClosed) return;

          switch (result) {
            case Success():
              AppLogger.success('Feedback deleted successfully');
              emit(
                DashboardFeedbacksLoaded(
                  feedbacks: _repository.cachedFeedbacks,
                  actionMessage: AppStrings.deletedSuccessfully,
                ),
              );
            case FailureResult(:final failure):
              unawaited(
                AppLogger.localError(
                  'Failed to delete feedback offline queue: ${failure.message}',
                ),
              );
              // Rollback
              emit(
                DashboardFeedbacksLoaded(
                  feedbacks: _repository.cachedFeedbacks,
                  actionMessage: failure.message,
                  isError: true,
                ),
              );
          }
        }),
      );
    }
  }
}

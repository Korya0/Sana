import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/developer_dashboard/data/repos/dashboard_repository.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardInitial());

  final IDashboardRepository _repository;

  Future<void> getFeedbacks() async {
    emit(const DashboardFeedbacksLoading());
    final result = await _repository.getFeedbacks();

    result.when(
      success: (feedbacks) {
        emit(DashboardFeedbacksLoaded(feedbacks: feedbacks));
      },
      failure: (failure) {
        emit(DashboardFeedbacksError(message: failure.message));
      },
    );
  }

  void deleteFeedback(String id) {
    if (state is DashboardFeedbacksLoaded) {
      final currentState = state as DashboardFeedbacksLoaded;
      final currentFeedbacks = currentState.feedbacks;
      final feedbackToRemove = currentFeedbacks.firstWhere((f) => f.id == id);

      // Optimistic update
      final newFeedbacks = currentFeedbacks.where((f) => f.id != id).toList();
      emit(DashboardFeedbacksLoaded(feedbacks: newFeedbacks));

      // Fire and forget deletion
      unawaited(
        _repository.deleteFeedback(id).then((result) async {
          await result.when(
            success: (_) {
              AppLogger.success('Feedback deleted successfully');
            },
            failure: (failure) async {
              // Rollback if there's an error
              await AppLogger.error(
                'Failed to delete feedback offline queue: ${failure.message}',
              );
              emit(
                DashboardFeedbacksLoaded(
                  feedbacks: [...newFeedbacks, feedbackToRemove]
                    ..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
                ),
              );
            },
          );
        }),
      );
    }
  }
}

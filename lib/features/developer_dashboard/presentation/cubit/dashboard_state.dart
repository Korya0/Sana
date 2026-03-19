import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';

part 'dashboard_state.freezed.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = DashboardInitial;
  const factory DashboardState.loading() = DashboardFeedbacksLoading;
  const factory DashboardState.loaded({
    required List<DashboardFeedbackModel> feedbacks,
  }) = DashboardFeedbacksLoaded;
  const factory DashboardState.error({
    required String message,
  }) = DashboardFeedbacksError;
}

import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';

sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardFeedbacksLoading extends DashboardState {
  const DashboardFeedbacksLoading();
}

class DashboardFeedbacksLoaded extends DashboardState {
  const DashboardFeedbacksLoaded({required this.feedbacks});
  final List<DashboardFeedbackModel> feedbacks;
}

class DashboardFeedbacksError extends DashboardState {
  const DashboardFeedbacksError({required this.message});
  final String message;
}

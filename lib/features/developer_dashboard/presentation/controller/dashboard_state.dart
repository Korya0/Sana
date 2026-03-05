import 'package:equatable/equatable.dart';
import 'package:sana/features/developer_dashboard/data/models/dashboard_feedback_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [feedbacks];
}

class DashboardFeedbacksError extends DashboardState {
  const DashboardFeedbacksError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

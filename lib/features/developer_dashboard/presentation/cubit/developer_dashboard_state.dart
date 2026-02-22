import 'package:equatable/equatable.dart';
import 'package:sana/features/developer_dashboard/data/models/report_model.dart';

abstract class DeveloperDashboardState extends Equatable {
  const DeveloperDashboardState();

  @override
  List<Object> get props => [];
}

class DeveloperDashboardInitial extends DeveloperDashboardState {}

class DeveloperDashboardLoading extends DeveloperDashboardState {}

class DeveloperDashboardLoaded extends DeveloperDashboardState {
  const DeveloperDashboardLoaded(this.reports);
  final List<ReportModel> reports;

  @override
  List<Object> get props => [reports];
}

class DeveloperDashboardError extends DeveloperDashboardState {
  const DeveloperDashboardError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

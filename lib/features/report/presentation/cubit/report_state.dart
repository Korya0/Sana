abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportSending extends ReportState {}

class ReportSuccess extends ReportState {
  ReportSuccess({required this.message});
  final String message;
}

class ReportFailure extends ReportState {
  ReportFailure({required this.error});
  final String error;
}

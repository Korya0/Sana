abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportSending extends ReportState {}

class ReportSuccess extends ReportState {
  final String message;
  ReportSuccess({required this.message});
}

class ReportFailure extends ReportState {
  final String error;
  ReportFailure({required this.error});
}

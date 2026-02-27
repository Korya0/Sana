part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportSending extends ReportState {}

class ReportSuccess extends ReportState {
  const ReportSuccess({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class ReportFailure extends ReportState {
  const ReportFailure({required this.error, this.technicalMessage});
  final String error;
  final String? technicalMessage;

  @override
  List<Object?> get props => [error, technicalMessage];
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/report/constant/string_constant.dart';
import 'package:sana/features/report/data/repositories/report_repository.dart';
part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit({required this.repository}) : super(ReportInitial());
  final IReportRepository repository;

  Future<void> sendReport({
    required String issueDescription,
    String? errorDetails,
    String? contactInfo,
    bool isSuggestion = false,
  }) async {
    emit(ReportSending());
    final result = await repository.sendReport(
      message: issueDescription,
      errorDetails: errorDetails,
      contactInfo: contactInfo,
      isSuggestion: isSuggestion,
    );
    result.fold(
      (failure) => emit(
        ReportFailure(
          error: failure.message,
          technicalMessage: failure.technicalMessage,
        ),
      ),
      (_) => emit(
        const ReportSuccess(message: StringConstant.reportSentSuccessfully),
      ),
    );
  }
}

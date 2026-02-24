import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/report/data/report_repository.dart';
import 'package:sana/features/report/presentation/controller/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit({ReportRepository? repository})
    : _repository = repository ?? ReportRepository(),
      super(ReportInitial());
  final ReportRepository _repository;

  Future<void> sendReport({
    required String issueDescription,
    String? errorDetails,
    bool isSuggestion = false,
  }) async {
    emit(ReportSending());
    final result = await _repository.sendReport(
      message: issueDescription,
      errorDetails: errorDetails,
      isSuggestion: isSuggestion,
    );
    result.fold(
      (failure) => emit(ReportFailure(error: failure.message)),
      (_) => emit(ReportSuccess(message: 'تم إرسال البلاغ بنجاح')),
    );
  }
}

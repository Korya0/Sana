import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_state.dart';
import '../../data/report_repository.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _repository;

  ReportCubit({ReportRepository? repository})
    : _repository = repository ?? ReportRepository(),
      super(ReportInitial());

  Future<void> sendReport({
    required String issueDescription,
    String? errorDetails,
    bool isSuggestion = false,
  }) async {
    try {
      emit(ReportSending());
      await _repository.sendReport(
        message: issueDescription,
        errorDetails: errorDetails,
        isSuggestion: isSuggestion,
      );
      emit(ReportSuccess(message: 'تم إرسال البلاغ بنجاح'));
    } catch (e) {
      emit(ReportFailure(error: 'حدث خطأ أثناء إرسال البلاغ'));
    }
  }
}

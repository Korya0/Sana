import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/feedback/domain/repos/i_feedback_repository.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit({required this.repository}) : super(const FeedbackInitial());
  final IFeedbackRepository repository;

  Future<void> sendFeedback({
    required String issueDescription,
    String? contactInfo,
  }) async {
    emit(const FeedbackSending());
    final result = await repository.sendFeedback(
      message: issueDescription,
      contactInfo: contactInfo,
    );
    if (isClosed) return;
    switch (result) {
      case Success():
        emit(
          const FeedbackSuccess(
            message: AppStrings.thanksForYourContribution,
          ),
        );
      case FailureResult(:final failure):
        emit(
          FeedbackFailure(
            error: failure.message,
          ),
        );
    }
  }
}

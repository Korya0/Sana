import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/feedback/data/repositories/feedback_repository.dart';
import 'package:sana/features/feedback/presentation/controller/feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit({required this.repository}) : super(FeedbackInitial());
  final IFeedbackRepository repository;

  Future<void> sendFeedback({
    required String issueDescription,
    String? contactInfo,
  }) async {
    emit(FeedbackSending());
    final result = await repository.sendFeedback(
      message: issueDescription,
      contactInfo: contactInfo,
    );
    result.fold(
      (failure) => emit(
        FeedbackFailure(
          error: failure.message,
        ),
      ),
      (_) => emit(
        const FeedbackSuccess(
          message: AppStrings.thanksForYourContribution,
        ),
      ),
    );
  }
}

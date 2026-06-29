import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/feedback/data/repos/feedback_repository.dart';
import 'package:sana/core/networking/api_result.dart';
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
    switch (result) {
      case Success():
        emit(
          const FeedbackSuccess(
            message: AppStrings.thanksForYourContribution,
          ),
        );
      case ApiFailure(:final failure):
        emit(
          FeedbackFailure(
            error: failure.message,
          ),
        );
    }
  }
}

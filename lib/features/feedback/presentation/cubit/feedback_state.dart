import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_state.freezed.dart';

@freezed
class FeedbackState with _$FeedbackState {
  const factory FeedbackState.initial() = FeedbackInitial;
  const factory FeedbackState.sending() = FeedbackSending;
  const factory FeedbackState.success({required String message}) =
      FeedbackSuccess;
  const factory FeedbackState.failure({required String error}) =
      FeedbackFailure;
}

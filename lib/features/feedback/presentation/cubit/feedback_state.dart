sealed class FeedbackState {
  const FeedbackState();
}

class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}

class FeedbackSending extends FeedbackState {
  const FeedbackSending();
}

class FeedbackSuccess extends FeedbackState {
  const FeedbackSuccess({required this.message});
  final String message;
}

class FeedbackFailure extends FeedbackState {
  const FeedbackFailure({required this.error});
  final String error;
}

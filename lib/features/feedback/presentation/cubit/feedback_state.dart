import 'package:flutter/foundation.dart';

@immutable
sealed class FeedbackState {
  const FeedbackState();
}

class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FeedbackInitial;

  @override
  int get hashCode => 0;
}

class FeedbackSending extends FeedbackState {
  const FeedbackSending();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FeedbackSending;

  @override
  int get hashCode => 1;
}

class FeedbackSuccess extends FeedbackState {
  const FeedbackSuccess({required this.message});
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackSuccess && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class FeedbackFailure extends FeedbackState {
  const FeedbackFailure({required this.error});
  final String error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedbackFailure && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

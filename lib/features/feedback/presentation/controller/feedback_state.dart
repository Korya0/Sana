import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();
  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackSending extends FeedbackState {}

class FeedbackSuccess extends FeedbackState {
  const FeedbackSuccess({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class FeedbackFailure extends FeedbackState {
  const FeedbackFailure({required this.error, this.technicalMessage});
  final String error;
  final String? technicalMessage;

  @override
  List<Object?> get props => [error, technicalMessage];
}

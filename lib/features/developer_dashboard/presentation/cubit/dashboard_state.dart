import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/features/developer_dashboard/domain/entities/feedback_entity.dart';

@immutable
sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();

  @override
  bool operator ==(Object other) => identical(this, other) || other is DashboardInitial;

  @override
  int get hashCode => 0;
}

class DashboardFeedbacksLoading extends DashboardState {
  const DashboardFeedbacksLoading();

  @override
  bool operator ==(Object other) => identical(this, other) || other is DashboardFeedbacksLoading;

  @override
  int get hashCode => 1;
}

class DashboardFeedbacksLoaded extends DashboardState {
  const DashboardFeedbacksLoaded({
    required this.feedbacks,
    this.actionMessage,
    this.isError = false,
  });

  final List<FeedbackEntity> feedbacks;
  final String? actionMessage;
  final bool isError;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
    return other is DashboardFeedbacksLoaded &&
        listEquals(other.feedbacks, feedbacks) &&
        other.actionMessage == actionMessage &&
        other.isError == isError;
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(feedbacks) ^ actionMessage.hashCode ^ isError.hashCode;
}

class DashboardFeedbacksError extends DashboardState {
  const DashboardFeedbacksError({required this.message});
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardFeedbacksError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

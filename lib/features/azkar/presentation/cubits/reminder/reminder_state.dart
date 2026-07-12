import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';

sealed class ReminderState {
  const ReminderState();
}

@immutable
final class ReminderInitial extends ReminderState {
  const ReminderInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReminderInitial;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
final class ReminderLoading extends ReminderState {
  const ReminderLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReminderLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

@immutable
final class ReminderLoaded extends ReminderState {
  const ReminderLoaded(this.reminders);

  final List<ReminderEntity> reminders;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReminderLoaded &&
        const DeepCollectionEquality().equals(other.reminders, reminders);
  }

  @override
  int get hashCode => Object.hashAll(reminders);
}

@immutable
final class ReminderError extends ReminderState {
  const ReminderError(this.message);

  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReminderError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

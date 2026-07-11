import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';

sealed class ReminderState {
  const ReminderState();
}

@immutable
final class ReminderInitial extends ReminderState {
  const ReminderInitial();
}

@immutable
final class ReminderLoading extends ReminderState {
  const ReminderLoading();
}

@immutable
final class ReminderLoaded extends ReminderState {
  const ReminderLoaded(this.reminders);

  final List<ReminderEntity> reminders;
}

@immutable
final class ReminderError extends ReminderState {
  const ReminderError(this.message);

  final String message;
}

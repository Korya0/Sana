import 'package:flutter/foundation.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';

@immutable
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
  const ReminderLoaded(this.settings);
  final ReminderSettingsModel settings;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderLoaded &&
          runtimeType == other.runtimeType &&
          settings == other.settings;

  @override
  int get hashCode => settings.hashCode;
}

@immutable
final class ReminderError extends ReminderState {
  const ReminderError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

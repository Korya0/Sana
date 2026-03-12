import 'package:equatable/equatable.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object?> get props => [];
}

class ReminderInitial extends ReminderState {}

class ReminderLoading extends ReminderState {}

class ReminderLoaded extends ReminderState {
  const ReminderLoaded(this.settings);
  final ReminderSettings settings;

  @override
  List<Object?> get props => [settings];
}

class ReminderError extends ReminderState {
  const ReminderError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

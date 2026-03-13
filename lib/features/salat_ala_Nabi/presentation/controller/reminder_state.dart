import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';

part 'reminder_state.freezed.dart';

@freezed
class ReminderState with _$ReminderState {
  const factory ReminderState.initial() = ReminderInitial;
  const factory ReminderState.loading() = ReminderLoading;
  const factory ReminderState.loaded(ReminderSettings settings) =
      ReminderLoaded;
  const factory ReminderState.error(String message) = ReminderError;
}

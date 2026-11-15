import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';

sealed class ReadingSettingsState {
  // Creates state
  const ReadingSettingsState();
}

class ReadingSettingsInitial extends ReadingSettingsState {}

class ReadingSettingsLoaded extends ReadingSettingsState {
  // Creates state
  const ReadingSettingsLoaded(this.settings);

  final ReadingSettingsEntity settings;
}

class ReadingSettingsError extends ReadingSettingsState {
  // Creates state
  const ReadingSettingsError(this.message, {this.settings});

  final String message;
  final ReadingSettingsEntity? settings;
}

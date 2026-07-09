import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';

@immutable
sealed class ReadingSettingsState {
  const ReadingSettingsState();
}

class ReadingSettingsInitial extends ReadingSettingsState {
  const ReadingSettingsInitial();
}

class ReadingSettingsLoaded extends ReadingSettingsState {
  const ReadingSettingsLoaded(this.settings);
  final ReadingSettings settings;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReadingSettingsLoaded && other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;
}

class ReadingSettingsError extends ReadingSettingsState {
  const ReadingSettingsError(this.message);
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReadingSettingsError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

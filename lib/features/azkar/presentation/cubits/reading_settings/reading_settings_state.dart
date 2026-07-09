import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/data/models/reading_settings_model.dart';

@immutable
sealed class ReadingSettingsState {
  const ReadingSettingsState();
}

class ReadingSettingsInitial extends ReadingSettingsState {
  const ReadingSettingsInitial();
}

class ReadingSettingsLoaded extends ReadingSettingsState {
  const ReadingSettingsLoaded(this.settings, {this.isScreenReaderSupported = true});
  final ReadingSettingsModel settings;
  final bool isScreenReaderSupported;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReadingSettingsLoaded &&
        other.settings == settings &&
        other.isScreenReaderSupported == isScreenReaderSupported;
  }

  @override
  int get hashCode => Object.hash(settings, isScreenReaderSupported);
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

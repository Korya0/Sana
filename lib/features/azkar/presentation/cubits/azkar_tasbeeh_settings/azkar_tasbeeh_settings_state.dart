import 'package:flutter/foundation.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';

@immutable
sealed class AzkarTasbeehSettingsState {
  // Creates state
  const AzkarTasbeehSettingsState();

  // Returns settings with defaults
  AzkarTasbeehSettingsEntity get settingsOrDefault;
}

class AzkarTasbeehSettingsInitial extends AzkarTasbeehSettingsState {
  // Creates state
  const AzkarTasbeehSettingsInitial();

  @override
  AzkarTasbeehSettingsEntity get settingsOrDefault => _defaults;
}

class AzkarTasbeehSettingsLoaded extends AzkarTasbeehSettingsState {
  // Creates state
  const AzkarTasbeehSettingsLoaded(this.settings);

  final AzkarTasbeehSettingsEntity settings;

  @override
  AzkarTasbeehSettingsEntity get settingsOrDefault => settings;
}

class AzkarTasbeehSettingsError extends AzkarTasbeehSettingsState {
  // Creates state
  const AzkarTasbeehSettingsError(this.message, {this.settings});

  final String message;
  final AzkarTasbeehSettingsEntity? settings;

  @override
  AzkarTasbeehSettingsEntity get settingsOrDefault => settings ?? _defaults;
}

final AzkarTasbeehSettingsEntity _defaults = AzkarTasbeehSettingsEntity(
  fontSize: AzkarTasbeehSettingsEntity.defaultFontSize,
);

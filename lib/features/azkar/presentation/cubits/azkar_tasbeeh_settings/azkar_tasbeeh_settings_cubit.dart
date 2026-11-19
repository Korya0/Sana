import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';

class AzkarTasbeehSettingsCubit extends Cubit<AzkarTasbeehSettingsState> {
  // Creates cubit
  AzkarTasbeehSettingsCubit(this._getSettings, this._updateSettings)
    : super(const AzkarTasbeehSettingsInitial());

  final GetAzkarTasbeehSettingsUseCase _getSettings;
  final UpdateAzkarTasbeehSettingsUseCase _updateSettings;

  // Last persisted settings, used to revert after a failed save.
  AzkarTasbeehSettingsEntity? _persisted;

  // Loads settings
  Future<void> loadSettings() async {
    final result = await _getSettings();
    if (isClosed) return;

    switch (result) {
      case Success(data: final settings):
        _persisted = settings;
        emit(AzkarTasbeehSettingsLoaded(settings));
      case FailureResult(:final failure):
        emit(AzkarTasbeehSettingsError(failure.message));
    }
  }

  // Updates font size
  void previewFontSize(double newSize) {
    final settings = state.settingsOrDefault;

    emit(AzkarTasbeehSettingsLoaded(settings.copyWith(fontSize: newSize)));
  }

  // Updates haptics
  void previewHapticFeedbackEnabled(bool enabled) {
    final settings = state.settingsOrDefault;

    emit(
      AzkarTasbeehSettingsLoaded(
        settings.copyWith(hapticFeedbackEnabled: enabled),
      ),
    );
  }

  // Sets and saves font size
  Future<void> setFontSize(double size) async {
    previewFontSize(size);
    await saveSettings();
  }

  // Updates volume button counting
  void previewVolumeButtonCountEnabled(bool enabled) {
    final settings = state.settingsOrDefault;

    emit(
      AzkarTasbeehSettingsLoaded(
        settings.copyWith(volumeButtonCountEnabled: enabled),
      ),
    );
  }

  // Sets and saves haptics
  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    previewHapticFeedbackEnabled(enabled);
    await saveSettings();
  }

  // Sets and saves volume button counting
  Future<void> setVolumeButtonCountEnabled(bool enabled) async {
    previewVolumeButtonCountEnabled(enabled);
    await saveSettings();
  }

  // Saves settings
  Future<void> saveSettings() async {
    final current = state;
    if (current is! AzkarTasbeehSettingsLoaded) return;

    final result = await _updateSettings(current.settings);
    if (isClosed) return;

    if (result is FailureResult<void>) {
      emit(
        AzkarTasbeehSettingsError(
          result.failure.message,
          settings: _persisted,
        ),
      );
      return;
    }

    _persisted = current.settings;
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/data/models/reading_settings_model.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

class ReadingSettingsCubit extends Cubit<ReadingSettingsState> {
  ReadingSettingsCubit(this._repository) : super(const ReadingSettingsInitial());

  final IReadingSettingsRepository _repository;

  Future<void> loadSettings() async {
    final result = await _repository.getReadingSettings();
    final isSupported = _checkScreenReaderSupport();

    if (result is Success<ReadingSettingsModel>) {
      emit(ReadingSettingsLoaded(result.data, isScreenReaderSupported: isSupported));
    } else if (result is FailureResult<ReadingSettingsModel>) {
      emit(ReadingSettingsError(result.failure.message));
    }
  }

  bool _checkScreenReaderSupport() {
    // Screen readers (TalkBack / VoiceOver) are natively supported on Android, iOS, and Web.
    return true;
  }

  void changeFontSize(double newSize) {
    if (state is ReadingSettingsLoaded) {
      final loadedState = state as ReadingSettingsLoaded;
      emit(
        ReadingSettingsLoaded(
          loadedState.settings.copyWith(fontSize: newSize),
          isScreenReaderSupported: loadedState.isScreenReaderSupported,
        ),
      );
    } else {
      emit(
        ReadingSettingsLoaded(
          ReadingSettingsModel.defaultSettings().copyWith(fontSize: newSize),
          isScreenReaderSupported: _checkScreenReaderSupport(),
        ),
      );
    }
  }

  void toggleScreenAwake() {
    if (state is ReadingSettingsLoaded) {
      final loadedState = state as ReadingSettingsLoaded;
      emit(
        ReadingSettingsLoaded(
          loadedState.settings.copyWith(
            keepScreenAwake: !loadedState.settings.keepScreenAwake,
          ),
          isScreenReaderSupported: loadedState.isScreenReaderSupported,
        ),
      );
    } else {
      emit(
        ReadingSettingsLoaded(
          ReadingSettingsModel.defaultSettings().copyWith(
            keepScreenAwake: true,
          ),
          isScreenReaderSupported: _checkScreenReaderSupport(),
        ),
      );
    }
  }

  void toggleScreenReader() {
    if (state is ReadingSettingsLoaded) {
      final loadedState = state as ReadingSettingsLoaded;
      emit(
        ReadingSettingsLoaded(
          loadedState.settings.copyWith(
            screenReaderEnabled: !loadedState.settings.screenReaderEnabled,
          ),
          isScreenReaderSupported: loadedState.isScreenReaderSupported,
        ),
      );
    } else {
      emit(
        ReadingSettingsLoaded(
          ReadingSettingsModel.defaultSettings().copyWith(
            screenReaderEnabled: true,
          ),
          isScreenReaderSupported: _checkScreenReaderSupport(),
        ),
      );
    }
  }

  Future<void> saveSettings() async {
    if (state is! ReadingSettingsLoaded) return;

    final loadedState = state as ReadingSettingsLoaded;
    final result = await _repository.updateReadingSettings(loadedState.settings);

    if (result is FailureResult<void>) {
      emit(ReadingSettingsError(result.failure.message));
    }
  }
}

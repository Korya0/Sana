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

    if (result is Success<ReadingSettingsModel>) {
      emit(ReadingSettingsLoaded(result.data));
    } else if (result is FailureResult<ReadingSettingsModel>) {
      emit(ReadingSettingsError(result.failure.message));
    }
  }

  void changeFontSize(double newSize) {
    if (state is ReadingSettingsLoaded) {
      final currentSettings = (state as ReadingSettingsLoaded).settings;
      emit(ReadingSettingsLoaded(currentSettings.copyWith(fontSize: newSize)));
    } else {
      emit(
        ReadingSettingsLoaded(
          ReadingSettingsModel.defaultSettings().copyWith(fontSize: newSize),
        ),
      );
    }
  }

  void toggleScreenAwake() {
    if (state is ReadingSettingsLoaded) {
      final currentSettings = (state as ReadingSettingsLoaded).settings;
      emit(
        ReadingSettingsLoaded(
          currentSettings.copyWith(
            keepScreenAwake: !currentSettings.keepScreenAwake,
          ),
        ),
      );
    } else {
      emit(
        ReadingSettingsLoaded(
          ReadingSettingsModel.defaultSettings().copyWith(
            keepScreenAwake: true,
          ),
        ),
      );
    }
  }

  void toggleScreenReader() {
    if (state is ReadingSettingsLoaded) {
      final currentSettings = (state as ReadingSettingsLoaded).settings;
      emit(
        ReadingSettingsLoaded(
          currentSettings.copyWith(
            screenReaderEnabled: !currentSettings.screenReaderEnabled,
          ),
        ),
      );
    } else {
      emit(
        ReadingSettingsLoaded(
          ReadingSettingsModel.defaultSettings().copyWith(
            screenReaderEnabled: true,
          ),
        ),
      );
    }
  }

  Future<void> saveSettings() async {
    if (state is! ReadingSettingsLoaded) return;

    final currentSettings = (state as ReadingSettingsLoaded).settings;
    final result = await _repository.updateReadingSettings(currentSettings);

    if (result is FailureResult<void>) {
      emit(ReadingSettingsError(result.failure.message));
    }
  }
}

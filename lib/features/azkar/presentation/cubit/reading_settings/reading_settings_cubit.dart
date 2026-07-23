import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/usecases/get_reading_settings_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/update_reading_settings_usecase.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_state.dart';

class ReadingSettingsCubit extends Cubit<ReadingSettingsState> {
  ReadingSettingsCubit(this._getSettings, this._updateSettings)
      : super(const ReadingSettingsInitial());

  final GetReadingSettingsUseCase _getSettings;
  final UpdateReadingSettingsUseCase _updateSettings;

  Future<void> loadSettings() async {
    final result = await _getSettings();

    if (result is Success<ReadingSettings>) {
      emit(ReadingSettingsLoaded(result.data));
    } else if (result is FailureResult<ReadingSettings>) {
      emit(ReadingSettingsError(result.failure.message));
    }
  }

  void changeFontSize(double newSize) {
    if (state is ReadingSettingsLoaded) {
      final loadedState = state as ReadingSettingsLoaded;
      emit(
        ReadingSettingsLoaded(
          loadedState.settings.copyWith(fontSize: newSize),
        ),
      );
    } else {
      emit(
        ReadingSettingsLoaded(
          ReadingSettings.defaultSettings().copyWith(fontSize: newSize),
        ),
      );
    }
  }

  Future<void> saveSettings() async {
    if (state is! ReadingSettingsLoaded) return;

    final loadedState = state as ReadingSettingsLoaded;
    final result = await _updateSettings(loadedState.settings);

    if (result is FailureResult<void>) {
      emit(ReadingSettingsError(result.failure.message));
    }
  }
}

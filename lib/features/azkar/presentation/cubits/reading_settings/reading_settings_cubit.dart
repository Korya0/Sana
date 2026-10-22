import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

class ReadingSettingsCubit extends Cubit<ReadingSettingsState> {
  ReadingSettingsCubit(this._getSettings, this._updateSettings)
    : super(ReadingSettingsInitial());

  final GetReadingSettingsUseCase _getSettings;
  final UpdateReadingSettingsUseCase _updateSettings;

  Future<void> loadSettings() async {
    final result = await _getSettings();
    if (isClosed) return;

    switch (result) {
      case Success(data: final settings):
        emit(ReadingSettingsLoaded(settings));
      case FailureResult(:final failure):
        emit(ReadingSettingsError(failure.message));
    }
  }

  void changeFontSize(double newSize) {
    final current = state;
    final settings = switch (current) {
      ReadingSettingsLoaded(:final settings) => settings,
      ReadingSettingsError(:final settings?) => settings,
      _ => ReadingSettingsEntity(
        fontSize: ReadingSettingsEntity.defaultFontSize,
      ),
    };

    emit(ReadingSettingsLoaded(settings.copyWith(fontSize: newSize)));
  }

  Future<void> saveSettings() async {
    final current = state;
    if (current is! ReadingSettingsLoaded) return;

    final result = await _updateSettings(current.settings);
    if (isClosed) return;

    if (result is FailureResult<void>) {
      emit(
        ReadingSettingsError(
          result.failure.message,
          settings: current.settings,
        ),
      );
    }
  }
}

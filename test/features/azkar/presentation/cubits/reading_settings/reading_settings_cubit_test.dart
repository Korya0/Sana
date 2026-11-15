import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

void main() {
  group('ReadingSettingsCubit', () {
    test('loads the saved settings', () async {
      final repository = _FakeRepository(
        settings: ReadingSettingsEntity(fontSize: 26),
      );
      final cubit = _createCubit(repository);

      await cubit.loadSettings();

      final state = cubit.state as ReadingSettingsLoaded;
      expect(state.settings.fontSize, 26);
    });

    test('emits the failure message when loading fails', () async {
      final cubit = _createCubit(_FakeRepository(loadFailure: true));

      await cubit.loadSettings();

      expect(
        (cubit.state as ReadingSettingsError).message,
        'تعذّر تحميل الإعدادات',
      );
    });

    test('changeFontSize from the initial state uses the default size', () {
      final cubit = _createCubit(_FakeRepository());

      cubit.changeFontSize(24);

      final state = cubit.state as ReadingSettingsLoaded;
      expect(state.settings.fontSize, 24);
    });

    test('changeFontSize keeps the loaded settings', () async {
      final repository = _FakeRepository(
        settings: ReadingSettingsEntity(fontSize: 26),
      );
      final cubit = _createCubit(repository);
      await cubit.loadSettings();

      cubit.changeFontSize(30);

      final state = cubit.state as ReadingSettingsLoaded;
      expect(state.settings.fontSize, 30);
      expect(repository.updateCalls, 0);
    });

    test('saveSettings does nothing before settings are loaded', () async {
      final repository = _FakeRepository();
      final cubit = _createCubit(repository);

      await cubit.saveSettings();

      expect(repository.updateCalls, 0);
      expect(cubit.state, isA<ReadingSettingsInitial>());
    });

    test('saveSettings stores the current size', () async {
      final repository = _FakeRepository(
        settings: ReadingSettingsEntity(fontSize: 26),
      );
      final cubit = _createCubit(repository);
      await cubit.loadSettings();
      cubit.changeFontSize(30);

      await cubit.saveSettings();

      expect(repository.saved?.fontSize, 30);
      expect(cubit.state, isA<ReadingSettingsLoaded>());
    });

    test('a failed save falls back to the persisted size', () async {
      final repository = _FakeRepository(
        settings: ReadingSettingsEntity(fontSize: 26),
        saveFailure: true,
      );
      final cubit = _createCubit(repository);
      await cubit.loadSettings();
      cubit.changeFontSize(30);

      await cubit.saveSettings();

      final state = cubit.state as ReadingSettingsError;
      expect(state.message, 'تعذّر حفظ الإعدادات');
      expect(state.settings?.fontSize, 26);
    });
  });
}

ReadingSettingsCubit _createCubit(_FakeRepository repository) =>
    ReadingSettingsCubit(
      GetReadingSettingsUseCase(repository),
      UpdateReadingSettingsUseCase(repository),
    );

class _FakeRepository implements ReadingSettingsRepository {
  _FakeRepository({
    this.settings,
    this.loadFailure = false,
    this.saveFailure = false,
  });

  final ReadingSettingsEntity? settings;
  final bool loadFailure;
  final bool saveFailure;
  int updateCalls = 0;
  ReadingSettingsEntity? saved;

  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async {
    if (loadFailure) {
      return const Result.failure(
        CacheFailure(message: 'تعذّر تحميل الإعدادات'),
      );
    }
    return Result.success(settings ?? ReadingSettingsEntity(fontSize: 20));
  }

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async {
    updateCalls++;
    if (saveFailure) {
      return const Result.failure(
        CacheFailure(message: 'تعذّر حفظ الإعدادات'),
      );
    }
    saved = settings;
    return const Result.success(null);
  }
}

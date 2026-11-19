import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';

void main() {
  group('AzkarTasbeehSettingsCubit', () {
    test('loads the saved settings', () async {
      final repository = _FakeRepository(
        settings: AzkarTasbeehSettingsEntity(fontSize: 26),
      );
      final cubit = _createCubit(repository);

      await cubit.loadSettings();

      final state = cubit.state as AzkarTasbeehSettingsLoaded;
      expect(state.settings.fontSize, 26);
    });

    test('emits the failure message when loading fails', () async {
      final cubit = _createCubit(_FakeRepository(loadFailure: true));

      await cubit.loadSettings();

      expect(
        (cubit.state as AzkarTasbeehSettingsError).message,
        'تعذّر تحميل الإعدادات',
      );
    });

    test('previewFontSize from the initial state uses the default size', () {
      final cubit = _createCubit(_FakeRepository());

      cubit.previewFontSize(24);

      final state = cubit.state as AzkarTasbeehSettingsLoaded;
      expect(state.settings.fontSize, 24);
    });

    test('previewFontSize keeps the loaded settings', () async {
      final repository = _FakeRepository(
        settings: AzkarTasbeehSettingsEntity(fontSize: 26),
      );
      final cubit = _createCubit(repository);
      await cubit.loadSettings();

      cubit.previewFontSize(30);

      final state = cubit.state as AzkarTasbeehSettingsLoaded;
      expect(state.settings.fontSize, 30);
      expect(repository.updateCalls, 0);
    });

    test('saveSettings does nothing before settings are loaded', () async {
      final repository = _FakeRepository();
      final cubit = _createCubit(repository);

      await cubit.saveSettings();

      expect(repository.updateCalls, 0);
      expect(cubit.state, isA<AzkarTasbeehSettingsInitial>());
    });

    test('saveSettings stores the current size', () async {
      final repository = _FakeRepository(
        settings: AzkarTasbeehSettingsEntity(fontSize: 26),
      );
      final cubit = _createCubit(repository);
      await cubit.loadSettings();
      cubit.previewFontSize(30);

      await cubit.saveSettings();

      expect(repository.saved?.fontSize, 30);
      expect(cubit.state, isA<AzkarTasbeehSettingsLoaded>());
    });

    test('a failed save falls back to the persisted size', () async {
      final repository = _FakeRepository(
        settings: AzkarTasbeehSettingsEntity(fontSize: 26),
        saveFailure: true,
      );
      final cubit = _createCubit(repository);
      await cubit.loadSettings();
      cubit.previewFontSize(30);

      await cubit.saveSettings();

      final state = cubit.state as AzkarTasbeehSettingsError;
      expect(state.message, 'تعذّر حفظ الإعدادات');
      expect(state.settings?.fontSize, 26);
    });

    test('previewHapticFeedbackEnabled updates state without saving', () {
      final cubit = _createCubit(_FakeRepository());

      cubit.previewHapticFeedbackEnabled(false);

      final state = cubit.state as AzkarTasbeehSettingsLoaded;
      expect(state.settings.hapticFeedbackEnabled, isFalse);
    });

    test('setFontSize applies and persists in one call', () async {
      final repository = _FakeRepository();
      final cubit = _createCubit(repository);

      await cubit.setFontSize(26);

      expect((cubit.state as AzkarTasbeehSettingsLoaded).settings.fontSize, 26);
      expect(repository.updateCalls, 1);
      expect(repository.saved?.fontSize, 26);
    });

    test('setHapticFeedbackEnabled applies and persists in one call', () async {
      final repository = _FakeRepository();
      final cubit = _createCubit(repository);

      await cubit.setHapticFeedbackEnabled(false);

      final state = cubit.state as AzkarTasbeehSettingsLoaded;
      expect(state.settings.hapticFeedbackEnabled, isFalse);
      expect(repository.updateCalls, 1);
      expect(repository.saved?.hapticFeedbackEnabled, isFalse);
    });

    test('previewVolumeButtonCountEnabled updates state without saving', () {
      final repository = _FakeRepository();
      final cubit = _createCubit(repository);

      cubit.previewVolumeButtonCountEnabled(false);

      final state = cubit.state as AzkarTasbeehSettingsLoaded;
      expect(state.settings.volumeButtonCountEnabled, isFalse);
      expect(repository.updateCalls, 0);
    });

    test(
      'setVolumeButtonCountEnabled applies and persists in one call',
      () async {
        final repository = _FakeRepository();
        final cubit = _createCubit(repository);

        await cubit.setVolumeButtonCountEnabled(false);

        final state = cubit.state as AzkarTasbeehSettingsLoaded;
        expect(state.settings.volumeButtonCountEnabled, isFalse);
        expect(repository.updateCalls, 1);
        expect(repository.saved?.volumeButtonCountEnabled, isFalse);
      },
    );

    test(
      'a failed volume button save falls back to the persisted value',
      () async {
        final repository = _FakeRepository(
          settings: AzkarTasbeehSettingsEntity(
            fontSize: 20,
            volumeButtonCountEnabled: false,
          ),
          saveFailure: true,
        );
        final cubit = _createCubit(repository);
        await cubit.loadSettings();

        await cubit.setVolumeButtonCountEnabled(true);

        final state = cubit.state as AzkarTasbeehSettingsError;
        expect(state.message, 'تعذّر حفظ الإعدادات');
        expect(state.settings?.volumeButtonCountEnabled, isFalse);
      },
    );
  });
}

AzkarTasbeehSettingsCubit _createCubit(_FakeRepository repository) =>
    AzkarTasbeehSettingsCubit(
      GetAzkarTasbeehSettingsUseCase(repository),
      UpdateAzkarTasbeehSettingsUseCase(repository),
    );

class _FakeRepository implements AzkarTasbeehSettingsRepository {
  _FakeRepository({
    this.settings,
    this.loadFailure = false,
    this.saveFailure = false,
  });

  final AzkarTasbeehSettingsEntity? settings;
  final bool loadFailure;
  final bool saveFailure;
  int updateCalls = 0;
  AzkarTasbeehSettingsEntity? saved;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async {
    if (loadFailure) {
      return const Result.failure(
        CacheFailure(message: 'تعذّر تحميل الإعدادات'),
      );
    }
    return Result.success(settings ?? AzkarTasbeehSettingsEntity(fontSize: 20));
  }

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
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

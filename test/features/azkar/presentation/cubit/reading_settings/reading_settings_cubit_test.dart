import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_usecase.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_usecase.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

class MockGetReadingSettingsUseCase extends Mock implements GetReadingSettingsUseCase {}
class MockUpdateReadingSettingsUseCase extends Mock implements UpdateReadingSettingsUseCase {}

void main() {
  late ReadingSettingsCubit cubit;
  late MockGetReadingSettingsUseCase mockGetSettings;
  late MockUpdateReadingSettingsUseCase mockUpdateSettings;

  setUpAll(() {
    registerFallbackValue(const ReadingSettings(fontSize: 20));
  });

  setUp(() {
    mockGetSettings = MockGetReadingSettingsUseCase();
    mockUpdateSettings = MockUpdateReadingSettingsUseCase();
    cubit = ReadingSettingsCubit(mockGetSettings, mockUpdateSettings);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state should be ReadingSettingsInitial', () {
    expect(cubit.state, isA<ReadingSettingsInitial>());
  });

  group('loadSettings()', () {
    test('should emit ReadingSettingsLoaded on success', () async {
      const settings = ReadingSettings(fontSize: 20);
      when(() => mockGetSettings()).thenAnswer(
        (_) async => const Result.success(settings),
      );

      await cubit.loadSettings();

      expect(cubit.state, isA<ReadingSettingsLoaded>());
      expect((cubit.state as ReadingSettingsLoaded).settings, settings);
    });

    test('should emit ReadingSettingsError on failure', () async {
      when(() => mockGetSettings()).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Error'),
        ),
      );

      await cubit.loadSettings();

      expect(cubit.state, isA<ReadingSettingsError>());
      expect((cubit.state as ReadingSettingsError).message, 'Error');
    });
  });

  group('changeFontSize()', () {
    test('should update fontSize when state is loaded', () async {
      const settings = ReadingSettings(fontSize: 20);
      when(() => mockGetSettings()).thenAnswer(
        (_) async => const Result.success(settings),
      );

      await cubit.loadSettings();
      cubit.changeFontSize(16);

      expect(cubit.state, isA<ReadingSettingsLoaded>());
      expect((cubit.state as ReadingSettingsLoaded).settings.fontSize, 16);
    });

    test('should use default + new fontSize when state is not loaded', () {
      cubit.changeFontSize(14);

      expect(cubit.state, isA<ReadingSettingsLoaded>());
      expect((cubit.state as ReadingSettingsLoaded).settings.fontSize, 14);
    });
  });

  group('saveSettings()', () {
    test('should call updateSettings with current settings', () async {
      const settings = ReadingSettings(fontSize: 20);
      when(() => mockGetSettings()).thenAnswer(
        (_) async => const Result.success(settings),
      );
      when(() => mockUpdateSettings(any())).thenAnswer(
        (_) async => const Result.success(null),
      );

      await cubit.loadSettings();
      await cubit.saveSettings();

      verify(() => mockUpdateSettings(settings)).called(1);
    });

    test('should emit ReadingSettingsError if save fails', () async {
      const settings = ReadingSettings(fontSize: 20);
      when(() => mockGetSettings()).thenAnswer(
        (_) async => const Result.success(settings),
      );
      when(() => mockUpdateSettings(any())).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Save error'),
        ),
      );

      await cubit.loadSettings();
      await cubit.saveSettings();

      expect(cubit.state, isA<ReadingSettingsError>());
      expect((cubit.state as ReadingSettingsError).message, 'Save error');
    });

    test('should do nothing if state is not ReadingSettingsLoaded', () async {
      await cubit.saveSettings();

      // State should remain as initial
      expect(cubit.state, isA<ReadingSettingsInitial>());
    });
  });
}

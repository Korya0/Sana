import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';

import 'package:sana/features/azkar/domain/entities/reading_settings.dart';
import 'package:sana/features/azkar/domain/usecases/get_reading_settings_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/update_reading_settings_usecase.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/reading_settings/reading_settings_state.dart';

class MockGetReadingSettingsUseCase extends Mock
    implements GetReadingSettingsUseCase {}

class MockUpdateReadingSettingsUseCase extends Mock
    implements UpdateReadingSettingsUseCase {}

class FakeReadingSettings extends Fake implements ReadingSettings {}

void main() {
  late ReadingSettingsCubit cubit;
  late MockGetReadingSettingsUseCase mockGetUseCase;
  late MockUpdateReadingSettingsUseCase mockUpdateUseCase;

  setUpAll(() {
    registerFallbackValue(FakeReadingSettings());
  });

  setUp(() {
    mockGetUseCase = MockGetReadingSettingsUseCase();
    mockUpdateUseCase = MockUpdateReadingSettingsUseCase();
    cubit = ReadingSettingsCubit(mockGetUseCase, mockUpdateUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state should be ReadingSettingsInitial', () {
    expect(cubit.state, const ReadingSettingsInitial());
  });

  group('loadSettings', () {
    const tSettings = ReadingSettings(fontSize: 22);
    const tFailure = CacheFailure(message: 'Load error');

    blocTest<ReadingSettingsCubit, ReadingSettingsState>(
      'should emit [ReadingSettingsLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetUseCase())
            .thenAnswer((_) async => const Result.success(tSettings));
        return cubit;
      },
      act: (cubit) => cubit.loadSettings(),
      expect: () => [
        const ReadingSettingsLoaded(tSettings),
      ],
      verify: (_) {
        verify(() => mockGetUseCase()).called(1);
      },
    );

    blocTest<ReadingSettingsCubit, ReadingSettingsState>(
      'should emit [ReadingSettingsError] when getting data fails',
      build: () {
        when(() => mockGetUseCase())
            .thenAnswer((_) async => const Result.failure(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.loadSettings(),
      expect: () => [
        const ReadingSettingsError('Load error'),
      ],
      verify: (_) {
        verify(() => mockGetUseCase()).called(1);
      },
    );
  });

  group('changeFontSize', () {
    const newSize = 25.0;

    blocTest<ReadingSettingsCubit, ReadingSettingsState>(
      'should emit [ReadingSettingsLoaded] with new size when state is loaded',
      build: () => cubit,
      seed: () => const ReadingSettingsLoaded(
        ReadingSettings(fontSize: 20),
      ),
      act: (cubit) => cubit.changeFontSize(newSize),
      expect: () => [
        const ReadingSettingsLoaded(
          ReadingSettings(fontSize: newSize),
        ),
      ],
    );

    blocTest<ReadingSettingsCubit, ReadingSettingsState>(
      'should emit [ReadingSettingsLoaded] with default settings modified if state is not loaded',
      build: () => cubit,
      act: (cubit) => cubit.changeFontSize(newSize),
      expect: () => [
        const ReadingSettingsLoaded(
          ReadingSettings(fontSize: newSize),
        ),
      ],
    );
  });

  group('saveSettings', () {
    const tSettings = ReadingSettings(fontSize: 28);
    const tFailure = CacheFailure(message: 'Save error');

    blocTest<ReadingSettingsCubit, ReadingSettingsState>(
      'should call updateUseCase and emit nothing if successful when state is loaded',
      build: () {
        when(() => mockUpdateUseCase(any()))
            .thenAnswer((_) async => const Result.success(null));
        return cubit;
      },
      seed: () => const ReadingSettingsLoaded(tSettings),
      act: (cubit) => cubit.saveSettings(),
      expect: () => <ReadingSettingsState>[],
      verify: (_) {
        verify(() => mockUpdateUseCase(tSettings)).called(1);
      },
    );

    blocTest<ReadingSettingsCubit, ReadingSettingsState>(
      'should emit [ReadingSettingsError] if updateUseCase fails',
      build: () {
        when(() => mockUpdateUseCase(any()))
            .thenAnswer((_) async => const Result.failure(tFailure));
        return cubit;
      },
      seed: () => const ReadingSettingsLoaded(tSettings),
      act: (cubit) => cubit.saveSettings(),
      expect: () => [
        const ReadingSettingsError('Save error'),
      ],
      verify: (_) {
        verify(() => mockUpdateUseCase(tSettings)).called(1);
      },
    );

    blocTest<ReadingSettingsCubit, ReadingSettingsState>(
      'should do nothing if state is not ReadingSettingsLoaded',
      build: () => cubit,
      act: (cubit) => cubit.saveSettings(),
      expect: () => <ReadingSettingsState>[],
      verify: (_) {
        verifyNever(() => mockUpdateUseCase(any()));
      },
    );
  });
}

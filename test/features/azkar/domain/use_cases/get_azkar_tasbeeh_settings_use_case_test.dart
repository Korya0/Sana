import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';

void main() {
  group('GetAzkarTasbeehSettingsUseCase', () {
    test('reads settings from the repository', () async {
      final repository = _FakeRepository(
        result: Result.success(AzkarTasbeehSettingsEntity(fontSize: 26)),
      );

      final result = await GetAzkarTasbeehSettingsUseCase(repository)();

      final success = result as Success<AzkarTasbeehSettingsEntity>;
      expect(success.data.fontSize, 26);
      expect(repository.readCalls, 1);
    });

    test('returns repository failures', () async {
      final repository = _FakeRepository(
        result: const Result.failure(CacheFailure(message: 'err')),
      );

      final result = await GetAzkarTasbeehSettingsUseCase(repository)();

      expect(result, isA<FailureResult<AzkarTasbeehSettingsEntity>>());
      expect((result as FailureResult).failure.message, 'err');
      expect(repository.readCalls, 1);
    });
  });
}

class _FakeRepository implements AzkarTasbeehSettingsRepository {
  _FakeRepository({required this.result});

  final Result<AzkarTasbeehSettingsEntity> result;
  int readCalls = 0;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async {
    readCalls++;
    return result;
  }

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';

void main() {
  group('UpdateAzkarTasbeehSettingsUseCase', () {
    test('saves settings through the repository', () async {
      final repository = _FakeRepository(
        result: const Result.success(null),
      );
      final settings = AzkarTasbeehSettingsEntity(fontSize: 28);

      final result = await UpdateAzkarTasbeehSettingsUseCase(repository)(
        settings,
      );

      expect(result, isA<Success<void>>());
      expect(repository.saved, same(settings));
    });

    test('returns repository failures', () async {
      final repository = _FakeRepository(
        result: const Result.failure(CacheFailure(message: 'save failed')),
      );
      final settings = AzkarTasbeehSettingsEntity(fontSize: 22);

      final result = await UpdateAzkarTasbeehSettingsUseCase(repository)(
        settings,
      );

      expect(result, isA<FailureResult<void>>());
      expect((result as FailureResult).failure.message, 'save failed');
      expect(repository.saved, same(settings));
    });
  });
}

class _FakeRepository implements AzkarTasbeehSettingsRepository {
  _FakeRepository({required this.result});

  final Result<void> result;
  AzkarTasbeehSettingsEntity? saved;

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async {
    saved = settings;
    return result;
  }

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 20));
}

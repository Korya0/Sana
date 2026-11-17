import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/update_azkar_tasbeeh_settings_use_case.dart';

void main() {
  test('saves settings through the repository', () async {
    final repository = _FakeRepository();
    final settings = AzkarTasbeehSettingsEntity(fontSize: 28);

    final result = await UpdateAzkarTasbeehSettingsUseCase(repository)(
      settings,
    );

    expect(result, isA<Success<void>>());
    expect(repository.saved, same(settings));
  });
}

class _FakeRepository implements AzkarTasbeehSettingsRepository {
  AzkarTasbeehSettingsEntity? saved;

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async {
    saved = settings;
    return const Result.success(null);
  }

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(AzkarTasbeehSettingsEntity(fontSize: 20));
}

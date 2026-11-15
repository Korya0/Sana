import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reading_settings_use_case.dart';

void main() {
  test('saves settings through the repository', () async {
    final repository = _FakeRepository();
    final settings = ReadingSettingsEntity(fontSize: 28);

    final result = await UpdateReadingSettingsUseCase(repository)(settings);

    expect(result, isA<Success<void>>());
    expect(repository.saved, same(settings));
  });
}

class _FakeRepository implements ReadingSettingsRepository {
  ReadingSettingsEntity? saved;

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async {
    saved = settings;
    return const Result.success(null);
  }

  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async =>
      Result.success(ReadingSettingsEntity(fontSize: 20));
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reading_settings_use_case.dart';

void main() {
  test('reads settings from the repository', () async {
    final repository = _FakeRepository(
      settings: ReadingSettingsEntity(fontSize: 26),
    );

    final result = await GetReadingSettingsUseCase(repository)();

    final success = result as Success<ReadingSettingsEntity>;
    expect(success.data.fontSize, 26);
    expect(repository.readCalls, 1);
  });
}

class _FakeRepository implements ReadingSettingsRepository {
  _FakeRepository({required this.settings});

  final ReadingSettingsEntity settings;
  int readCalls = 0;

  @override
  Future<Result<ReadingSettingsEntity>> getReadingSettings() async {
    readCalls++;
    return Result.success(settings);
  }

  @override
  Future<Result<void>> updateReadingSettings(
    ReadingSettingsEntity settings,
  ) async => const Result.success(null);
}

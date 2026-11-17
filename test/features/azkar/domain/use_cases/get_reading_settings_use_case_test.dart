import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_tasbeeh_settings_use_case.dart';

void main() {
  test('reads settings from the repository', () async {
    final repository = _FakeRepository(
      settings: AzkarTasbeehSettingsEntity(fontSize: 26),
    );

    final result = await GetAzkarTasbeehSettingsUseCase(repository)();

    final success = result as Success<AzkarTasbeehSettingsEntity>;
    expect(success.data.fontSize, 26);
    expect(repository.readCalls, 1);
  });
}

class _FakeRepository implements AzkarTasbeehSettingsRepository {
  _FakeRepository({required this.settings});

  final AzkarTasbeehSettingsEntity settings;
  int readCalls = 0;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async {
    readCalls++;
    return Result.success(settings);
  }

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async => const Result.success(null);
}

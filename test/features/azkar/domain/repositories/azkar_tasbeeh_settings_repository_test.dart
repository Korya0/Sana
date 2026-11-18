import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_tasbeeh_settings_repository.dart';

void main() {
  group('AzkarTasbeehSettingsRepository', () {
    test('can be implemented as a contract', () async {
      final repository = _FakeAzkarTasbeehSettingsRepository();

      expect(repository, isA<AzkarTasbeehSettingsRepository>());
      expect(
        await repository.getAzkarTasbeehSettings(),
        isA<Success<AzkarTasbeehSettingsEntity>>(),
      );
      expect(
        await repository.updateAzkarTasbeehSettings(
          AzkarTasbeehSettingsEntity(fontSize: 20),
        ),
        isA<Success<void>>(),
      );
    });

    test('loads and saves settings through the contract', () async {
      final repository = _FakeAzkarTasbeehSettingsRepository();

      final settings = AzkarTasbeehSettingsEntity(fontSize: 24);
      await repository.updateAzkarTasbeehSettings(settings);
      final result = await repository.getAzkarTasbeehSettings();

      expect((result as Success<AzkarTasbeehSettingsEntity>).data.fontSize, 24);
      expect(repository.saved?.fontSize, 24);
    });
  });
}

class _FakeAzkarTasbeehSettingsRepository
    implements AzkarTasbeehSettingsRepository {
  AzkarTasbeehSettingsEntity _current = AzkarTasbeehSettingsEntity(fontSize: 20);
  AzkarTasbeehSettingsEntity? saved;

  @override
  Future<Result<AzkarTasbeehSettingsEntity>> getAzkarTasbeehSettings() async =>
      Result.success(_current);

  @override
  Future<Result<void>> updateAzkarTasbeehSettings(
    AzkarTasbeehSettingsEntity settings,
  ) async {
    saved = settings;
    _current = settings;
    return const Result.success(null);
  }
}

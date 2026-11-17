import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';

void main() {
  group('AzkarTasbeehSettingsState.settingsOrDefault', () {
    test('initial uses defaults', () {
      final settings = const AzkarTasbeehSettingsInitial().settingsOrDefault;

      expect(settings.fontSize, AzkarTasbeehSettingsEntity.defaultFontSize);
      expect(
        settings.hapticFeedbackEnabled,
        AzkarTasbeehSettingsEntity.defaultHapticFeedbackEnabled,
      );
    });

    test('loaded returns its own settings', () {
      final entity = AzkarTasbeehSettingsEntity(fontSize: 26);

      expect(
        AzkarTasbeehSettingsLoaded(entity).settingsOrDefault,
        same(entity),
      );
    });

    test('error uses its carried settings when present', () {
      final entity = AzkarTasbeehSettingsEntity(fontSize: 28);

      expect(
        AzkarTasbeehSettingsError('failed', settings: entity).settingsOrDefault,
        same(entity),
      );
    });

    test('error without settings falls back to defaults', () {
      final settings = const AzkarTasbeehSettingsError(
        'failed',
      ).settingsOrDefault;

      expect(settings.fontSize, AzkarTasbeehSettingsEntity.defaultFontSize);
    });
  });
}

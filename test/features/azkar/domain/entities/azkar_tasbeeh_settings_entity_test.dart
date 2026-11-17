import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';

void main() {
  group('AzkarTasbeehSettingsEntity', () {
    test('clamps sizes below the minimum', () {
      expect(
        AzkarTasbeehSettingsEntity(fontSize: 2).fontSize,
        AzkarTasbeehSettingsEntity.minFontSize,
      );
      expect(
        AzkarTasbeehSettingsEntity.clampFontSize(-5),
        AzkarTasbeehSettingsEntity.minFontSize,
      );
    });

    test('clamps sizes above the maximum', () {
      expect(
        AzkarTasbeehSettingsEntity(fontSize: 99).fontSize,
        AzkarTasbeehSettingsEntity.maxFontSize,
      );
      expect(
        AzkarTasbeehSettingsEntity.clampFontSize(99),
        AzkarTasbeehSettingsEntity.maxFontSize,
      );
    });

    test('keeps an in-range size unchanged', () {
      expect(
        AzkarTasbeehSettingsEntity(fontSize: 24).fontSize,
        24,
      );
    });

    test('copyWith clamps the new size and keeps the existing one', () {
      final settings = AzkarTasbeehSettingsEntity(fontSize: 20);

      expect(settings.copyWith(fontSize: 40).fontSize, 32);
      expect(settings.copyWith().fontSize, 20);
    });
  });
}

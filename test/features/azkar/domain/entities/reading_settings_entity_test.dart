import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';

void main() {
  group('ReadingSettingsEntity', () {
    test('clamps sizes below the minimum', () {
      expect(
        ReadingSettingsEntity(fontSize: 2).fontSize,
        ReadingSettingsEntity.minFontSize,
      );
      expect(
        ReadingSettingsEntity.clampFontSize(-5),
        ReadingSettingsEntity.minFontSize,
      );
    });

    test('clamps sizes above the maximum', () {
      expect(
        ReadingSettingsEntity(fontSize: 99).fontSize,
        ReadingSettingsEntity.maxFontSize,
      );
      expect(
        ReadingSettingsEntity.clampFontSize(99),
        ReadingSettingsEntity.maxFontSize,
      );
    });

    test('keeps an in-range size unchanged', () {
      expect(
        ReadingSettingsEntity(fontSize: 24).fontSize,
        24,
      );
    });

    test('copyWith clamps the new size and keeps the existing one', () {
      final settings = ReadingSettingsEntity(fontSize: 20);

      expect(settings.copyWith(fontSize: 40).fontSize, 32);
      expect(settings.copyWith().fontSize, 20);
    });
  });
}

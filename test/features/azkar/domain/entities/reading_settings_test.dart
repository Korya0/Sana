import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings.dart';

void main() {
  group('ReadingSettings', () {
    test('should create ReadingSettings with fontSize', () {
      const settings = ReadingSettings(fontSize: 16);

      expect(settings.fontSize, 16);
    });

    test('defaultSettings() should return fontSize = 20', () {
      final settings = ReadingSettings.defaultSettings();

      expect(settings.fontSize, 20);
    });

    test('copyWith(fontSize:) should return a new instance with updated fontSize', () {
      const original = ReadingSettings(fontSize: 16);
      final updated = original.copyWith(fontSize: 20);

      expect(updated.fontSize, 20);
      expect(original.fontSize, 16);
      expect(updated, isNot(same(original)));
    });

    test('copyWith() without parameters should return an equal instance', () {
      const original = ReadingSettings(fontSize: 16);
      final copied = original.copyWith();

      expect(copied.fontSize, original.fontSize);
      expect(copied, isNot(same(original)));
    });

    group('equality', () {
      test('should be equal when fontSize is the same', () {
        const a = ReadingSettings(fontSize: 16);
        const b = ReadingSettings(fontSize: 16);

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('should not be equal when fontSize is different', () {
        const a = ReadingSettings(fontSize: 16);
        const b = ReadingSettings(fontSize: 20);

        expect(a, isNot(equals(b)));
      });
    });
  });
}
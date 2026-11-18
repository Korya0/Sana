import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';

void main() {
  group('AzkarCategoryEntity', () {
    test('creates an entity with required fields and defaults', () {
      const entity = AzkarCategoryEntity(
        key: 'morning',
        title: 'أذكار الصباح',
        cardTitle: 'الصباح',
      );

      expect(entity.key, 'morning');
      expect(entity.title, 'أذكار الصباح');
      expect(entity.cardTitle, 'الصباح');
      expect(entity.isCustom, isFalse);
      expect(entity.isModified, isFalse);
    });

    test('creates an entity with custom flags', () {
      const entity = AzkarCategoryEntity(
        key: 'custom_1',
        title: 'ورد',
        cardTitle: 'ورد',
        isCustom: true,
        isModified: true,
      );

      expect(entity.isCustom, isTrue);
      expect(entity.isModified, isTrue);
    });

    test('copyWith returns a copy with overridden values', () {
      const entity = AzkarCategoryEntity(
        key: 'morning',
        title: 'أذكار الصباح',
        cardTitle: 'الصباح',
      );

      final copy = entity.copyWith(
        key: 'evening',
        title: 'أذكار المساء',
        cardTitle: 'المساء',
        isCustom: true,
        isModified: true,
      );

      expect(copy.key, 'evening');
      expect(copy.title, 'أذكار المساء');
      expect(copy.cardTitle, 'المساء');
      expect(copy.isCustom, isTrue);
      expect(copy.isModified, isTrue);
    });

    test('copyWith preserves values when no overrides are provided', () {
      const entity = AzkarCategoryEntity(
        key: 'morning',
        title: 'أذكار الصباح',
        cardTitle: 'الصباح',
        isCustom: true,
        isModified: true,
      );

      final copy = entity.copyWith();

      expect(copy.key, entity.key);
      expect(copy.title, entity.title);
      expect(copy.cardTitle, entity.cardTitle);
      expect(copy.isCustom, entity.isCustom);
      expect(copy.isModified, entity.isModified);
    });

    test('copyWith can override a subset of fields', () {
      const entity = AzkarCategoryEntity(
        key: 'morning',
        title: 'أذكار الصباح',
        cardTitle: 'الصباح',
      );

      final copy = entity.copyWith(title: 'جديد', isModified: true);

      expect(copy.key, 'morning');
      expect(copy.title, 'جديد');
      expect(copy.cardTitle, 'الصباح');
      expect(copy.isCustom, isFalse);
      expect(copy.isModified, isTrue);
    });
  });
}

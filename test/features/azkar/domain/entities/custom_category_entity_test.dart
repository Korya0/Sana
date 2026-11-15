import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

void main() {
  group('CustomCategoryEntity', () {
    test('copyWith replaces only the provided fields', () {
      final createdAt = DateTime.utc(2026, 1, 1);
      final category = CustomCategoryEntity(
        id: 'custom_1',
        name: 'قسمي',
        azkar: const [ZikrEntity(id: 1, text: 'ذكر', count: 3)],
        createdAt: createdAt,
      );

      final copy = category.copyWith(name: 'قسم جديد');

      expect(copy.id, 'custom_1');
      expect(copy.name, 'قسم جديد');
      expect(copy.azkar, same(category.azkar));
      expect(copy.createdAt, createdAt);
    });

    test('toCategoryEntity exposes it as a custom category', () {
      const category = CustomCategoryEntity(
        id: 'custom_1',
        name: 'قسمي',
        azkar: [],
      );

      final entity = category.toCategoryEntity();

      expect(entity.key, 'custom_1');
      expect(entity.title, 'قسمي');
      expect(entity.cardTitle, 'قسمي');
      expect(entity.isCustom, isTrue);
      expect(entity.isModified, isFalse);
    });
  });
}

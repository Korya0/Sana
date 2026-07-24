import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/category_entity.dart';

void main() {
  group('CategoryEntity', () {
    test('should create CategoryEntity with id and title', () {
      const entity = CategoryEntity(id: 1, title: 'أذكار الصباح');

      expect(entity.id, 1);
      expect(entity.title, 'أذكار الصباح');
    });
  });
}

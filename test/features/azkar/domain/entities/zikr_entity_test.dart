import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

void main() {
  group('ZikrEntity', () {
    test('should create ZikrEntity with all required fields', () {
      const entity = ZikrEntity(
        id: 1,
        text: 'سُبْحَانَ اللَّهِ',
        count: 33,
        reference: 'متفق عليه',
        description: 'وصف مختصر',
      );

      expect(entity.id, 1);
      expect(entity.text, 'سُبْحَانَ اللَّهِ');
      expect(entity.count, 33);
      expect(entity.reference, 'متفق عليه');
      expect(entity.description, 'وصف مختصر');
    });

    test('reference and description should be nullable', () {
      const entity = ZikrEntity(
        id: 1,
        text: 'سُبْحَانَ اللَّهِ',
        count: 33,
      );

      expect(entity.reference, isNull);
      expect(entity.description, isNull);
    });

    test('description should be nullable when reference is provided', () {
      const entity = ZikrEntity(
        id: 1,
        text: 'سُبْحَانَ اللَّهِ',
        count: 33,
        reference: 'صحيح البخاري',
      );

      expect(entity.reference, 'صحيح البخاري');
      expect(entity.description, isNull);
    });
  });
}

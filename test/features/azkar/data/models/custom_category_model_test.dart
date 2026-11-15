import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/models/custom_category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';

void main() {
  group('CustomCategoryModel', () {
    test('round-trips every field through JSON', () {
      final createdAt = DateTime.utc(2026, 1, 2, 3, 4, 5);
      final model = CustomCategoryModel(
        id: 'custom_1',
        name: 'أذكار الصباح',
        azkar: const [
          ZikrModel(
            id: 1,
            text: 'سبحان الله',
            count: 33,
            description: 'تسبيح',
            isUserAdded: true,
          ),
        ],
        createdAt: createdAt,
      );

      final decoded = CustomCategoryModel.fromJson(model.toJson());

      expect(decoded.id, 'custom_1');
      expect(decoded.name, 'أذكار الصباح');
      expect(decoded.azkar.single.id, 1);
      expect(decoded.azkar.single.text, 'سبحان الله');
      expect(decoded.azkar.single.count, 33);
      expect(decoded.azkar.single.description, 'تسبيح');
      expect(decoded.azkar.single.isUserAdded, isTrue);
      expect(decoded.createdAt, createdAt);
    });

    test('omits createdAt from JSON when it is null', () {
      const model = CustomCategoryModel(id: 'custom_1', name: 'قسم', azkar: []);

      expect(model.toJson().containsKey(azkarCreatedAtKey), isFalse);
    });

    test('parses a stored category that has no createdAt', () {
      final decoded = CustomCategoryModel.fromJson({
        azkarIdKey: 'custom_1',
        azkarNameKey: 'قسم',
        azkarItemsKey: const <dynamic>[],
      });

      expect(decoded.createdAt, isNull);
      expect(decoded.azkar, isEmpty);
    });
  });
}

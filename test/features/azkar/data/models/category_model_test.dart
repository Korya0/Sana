import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/models/category_model.dart';

void main() {
  group('CategoryModel', () {
    test('fromJson should return CategoryModel with id and title from valid JSON', () {
      final json = <String, dynamic>{'id': 1, 'title': 'أذكار الصباح'};
      final model = CategoryModel.fromJson(json);

      expect(model.id, 1);
      expect(model.title, 'أذكار الصباح');
    });

    test('fromJson should throw if id is missing', () {
      final json = <String, dynamic>{'title': 'أذكار الصباح'};

      expect(
        () => CategoryModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('fromJson should throw if title is missing', () {
      final json = <String, dynamic>{'id': 1};

      expect(
        () => CategoryModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('fromJson should throw if id type is wrong (String instead of int)', () {
      final json = <String, dynamic>{'id': '1', 'title': 'أذكار الصباح'};

      expect(
        () => CategoryModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('CategoryModel should extend CategoryEntity', () {
      final json = <String, dynamic>{'id': 1, 'title': 'أذكار الصباح'};
      final model = CategoryModel.fromJson(json);

      expect(model, isA<CategoryModel>());
    });
  });
}

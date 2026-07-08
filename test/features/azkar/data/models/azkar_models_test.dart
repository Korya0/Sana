import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/models/category_model.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';

void main() {
  group('CategoryModel', () {
    test('should correctly parse from JSON', () {
      final json = {
        AzkarConstants.idKey: 1,
        AzkarConstants.titleKey: 'Title',
      };
      final model = CategoryModel.fromJson(json);
      expect(model.id, 1);
      expect(model.title, 'Title');
    });
  });

  group('ZikrModel', () {
    test('should correctly parse from JSON with all fields', () {
      final json = {
        AzkarConstants.idKey: 1,
        AzkarConstants.textKey: 'Text',
        AzkarConstants.countKey: 3,
        AzkarConstants.referenceKey: 'Ref',
        AzkarConstants.descriptionKey: 'Desc',
      };
      final model = ZikrModel.fromJson(json);
      expect(model.id, 1);
      expect(model.text, 'Text');
      expect(model.count, 3);
      expect(model.reference, 'Ref');
      expect(model.description, 'Desc');
    });

    test('should correctly parse from JSON with missing optional fields', () {
      final json = {
        AzkarConstants.idKey: 1,
        AzkarConstants.textKey: 'Text',
        AzkarConstants.countKey: 3,
      };
      final model = ZikrModel.fromJson(json);
      expect(model.id, 1);
      expect(model.text, 'Text');
      expect(model.count, 3);
      expect(model.reference, isNull);
      expect(model.description, isNull);
    });
  });
}

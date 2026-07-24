import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

void main() {
  group('ZikrModel', () {
    test('fromJson should return ZikrModel with all fields from valid JSON', () {
      final json = <String, dynamic>{
        'id': 1,
        'text': 'سُبْحَانَ اللَّهِ',
        'count': 33,
        'reference': 'متفق عليه',
        'description': 'وصف مختصر',
      };
      final model = ZikrModel.fromJson(json);

      expect(model.id, 1);
      expect(model.text, 'سُبْحَانَ اللَّهِ');
      expect(model.count, 33);
      expect(model.reference, 'متفق عليه');
      expect(model.description, 'وصف مختصر');
    });

    test('fromJson should work when reference is null', () {
      final json = <String, dynamic>{
        'id': 1,
        'text': 'سُبْحَانَ اللَّهِ',
        'count': 33,
      };
      final model = ZikrModel.fromJson(json);

      expect(model.id, 1);
      expect(model.text, 'سُبْحَانَ اللَّهِ');
      expect(model.count, 33);
      expect(model.reference, isNull);
      expect(model.description, isNull);
    });

    test('fromJson should work when description is null', () {
      final json = <String, dynamic>{
        'id': 1,
        'text': 'سُبْحَانَ اللَّهِ',
        'count': 33,
        'reference': 'متفق عليه',
      };
      final model = ZikrModel.fromJson(json);

      expect(model.reference, 'متفق عليه');
      expect(model.description, isNull);
    });

    test('fromJson should throw if id is missing', () {
      final json = <String, dynamic>{
        'text': 'سُبْحَانَ اللَّهِ',
        'count': 33,
      };

      expect(
        () => ZikrModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('fromJson should throw if text is missing', () {
      final json = <String, dynamic>{
        'id': 1,
        'count': 33,
      };

      expect(
        () => ZikrModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('fromJson should throw if count is missing', () {
      final json = <String, dynamic>{
        'id': 1,
        'text': 'سُبْحَانَ اللَّهِ',
      };

      expect(
        () => ZikrModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });

    test('ZikrModel should extend ZikrEntity', () {
      final json = <String, dynamic>{
        'id': 1,
        'text': 'سُبْحَانَ اللَّهِ',
        'count': 33,
      };
      final model = ZikrModel.fromJson(json);

      expect(model, isA<ZikrEntity>());
    });
  });
}

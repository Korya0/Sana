import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/data/models/zikr_model.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

void main() {
  group('ZikrModel', () {
    test('parses every field from JSON', () {
      final model = ZikrModel.fromJson({
        azkarIdKey: 7,
        azkarTextKey: 'سبحان الله',
        azkarCountKey: 33,
        azkarDescriptionKey: 'تسبيح',
        'is_user_added': true,
      });

      expect(model.id, 7);
      expect(model.text, 'سبحان الله');
      expect(model.count, 33);
      expect(model.description, 'تسبيح');
      expect(model.isUserAdded, isTrue);
    });

    test('defaults to not user-added when the flag is absent', () {
      expect(
        ZikrModel.fromJson({
          azkarIdKey: 100001,
          azkarTextKey: 'ذكر',
          azkarCountKey: 1,
        }).isUserAdded,
        isFalse,
      );
      expect(
        ZikrModel.fromJson({
          azkarIdKey: 1,
          azkarTextKey: 'ذكر',
          azkarCountKey: 1,
        }).isUserAdded,
        isFalse,
      );
    });

    test('reads the explicit flag regardless of id', () {
      final model = ZikrModel.fromJson({
        azkarIdKey: 1,
        azkarTextKey: 'ذكر',
        azkarCountKey: 1,
        azkarIsUserAddedKey: true,
      });

      expect(model.isUserAdded, isTrue);
    });

    test('toJson always writes the is_user_added flag', () {
      final userAdded = const ZikrModel(
        id: 1,
        text: 'ذكر',
        count: 1,
        isUserAdded: true,
      ).toJson();
      final builtIn = const ZikrModel(
        id: 1,
        text: 'ذكر',
        count: 1,
        isUserAdded: false,
      ).toJson();

      expect(userAdded[azkarIsUserAddedKey], isTrue);
      expect(builtIn[azkarIsUserAddedKey], isFalse);
    });

    test('round-trips through toJson', () {
      const model = ZikrModel(
        id: 5,
        text: 'الحمد لله',
        count: 10,
        description: 'حمد',
        isUserAdded: true,
      );

      final decoded = ZikrModel.fromJson(model.toJson());

      expect(decoded.id, model.id);
      expect(decoded.text, model.text);
      expect(decoded.count, model.count);
      expect(decoded.description, model.description);
      expect(decoded.isUserAdded, model.isUserAdded);
    });

    test('fromEntity copies every field', () {
      const entity = ZikrEntity(
        id: 9,
        text: 'الله أكبر',
        count: 3,
        description: 'تكبير',
        isUserAdded: true,
      );

      final model = ZikrModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.text, entity.text);
      expect(model.count, entity.count);
      expect(model.description, entity.description);
      expect(model.isUserAdded, entity.isUserAdded);
    });
  });
}

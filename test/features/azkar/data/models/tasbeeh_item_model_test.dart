import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/data/constants/tasbeeh_constants.dart';
import 'package:sana/features/azkar/data/models/tasbeeh_item_model.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

void main() {
  group('TasbeehItemModel', () {
    final date = DateTime(2026, 11, 17, 10, 30);

    test('parses every field from JSON', () {
      final model = TasbeehItemModel.fromJson({
        tasbeehIdKey: 't1',
        tasbeehTextKey: 'سبحان الله',
        tasbeehCurrentCountKey: 7,
        tasbeehTargetCountKey: 33,
        tasbeehLastUsedAtKey: date.toIso8601String(),
        tasbeehIsCustomKey: false,
      });

      expect(model.id, 't1');
      expect(model.text, 'سبحان الله');
      expect(model.currentCount, 7);
      expect(model.targetCount, 33);
      expect(model.lastUsedAt, date);
      expect(model.isCustom, isFalse);
    });

    test('uses safe defaults for missing fields', () {
      final model = TasbeehItemModel.fromJson({});

      expect(model.id, '');
      expect(model.text, '');
      expect(model.currentCount, 0);
      expect(model.targetCount, isNull);
      expect(model.isCustom, isTrue);
      expect(model.lastUsedAt, isA<DateTime>());
    });

    test('parses an epoch timestamp for lastUsedAt', () {
      final model = TasbeehItemModel.fromJson({
        tasbeehLastUsedAtKey: date.millisecondsSinceEpoch,
      });

      expect(model.lastUsedAt, date);
    });

    test('falls back to now for an invalid date string', () {
      final before = DateTime.now();
      final model = TasbeehItemModel.fromJson({
        tasbeehLastUsedAtKey: 'not-a-date',
      });

      expect(
        model.lastUsedAt.millisecondsSinceEpoch,
        greaterThanOrEqualTo(before.millisecondsSinceEpoch),
      );
    });

    test('treats a non-positive target as no target', () {
      final zero = TasbeehItemModel.fromJson({tasbeehTargetCountKey: 0});
      final negative = TasbeehItemModel.fromJson({
        tasbeehTargetCountKey: -5,
      });

      expect(zero.targetCount, isNull);
      expect(negative.targetCount, isNull);
    });

    test('toJson writes every key', () {
      final model = TasbeehItemModel(
        id: 't1',
        text: 'ذكر',
        currentCount: 3,
        targetCount: 10,
        lastUsedAt: date,
        isCustom: false,
      );

      final json = model.toJson();

      expect(json[tasbeehIdKey], 't1');
      expect(json[tasbeehTextKey], 'ذكر');
      expect(json[tasbeehCurrentCountKey], 3);
      expect(json[tasbeehTargetCountKey], 10);
      expect(json[tasbeehLastUsedAtKey], date.toIso8601String());
      expect(json[tasbeehIsCustomKey], isFalse);
    });

    test('round-trips through toJson', () {
      final model = TasbeehItemModel(
        id: 't1',
        text: 'الحمد لله',
        currentCount: 5,
        targetCount: 20,
        lastUsedAt: date,
      );

      final decoded = TasbeehItemModel.fromJson(model.toJson());

      expect(decoded, model);
    });

    test('fromEntity copies every field', () {
      final entity = TasbeehItemEntity(
        id: 't1',
        text: 'الله أكبر',
        currentCount: 2,
        targetCount: 10,
        lastUsedAt: date,
      );

      final model = TasbeehItemModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.text, entity.text);
      expect(model.currentCount, entity.currentCount);
      expect(model.targetCount, entity.targetCount);
      expect(model.lastUsedAt, entity.lastUsedAt);
      expect(model.isCustom, entity.isCustom);
    });
  });
}

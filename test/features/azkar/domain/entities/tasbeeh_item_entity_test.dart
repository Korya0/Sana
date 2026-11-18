import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';

void main() {
  final date = DateTime(2026, 11, 17);

  TasbeehItemEntity item({int count = 0, int? target}) => TasbeehItemEntity(
    id: 't1',
    text: 'ذكر',
    currentCount: count,
    targetCount: target,
    lastUsedAt: date,
  );

  group('TasbeehItemEntity', () {
    test('hasTarget is true only for a positive target', () {
      expect(item(target: 10).hasTarget, isTrue);
      expect(item(target: 0).hasTarget, isFalse);
      expect(item().hasTarget, isFalse);
    });

    test('isFreeMode mirrors a missing target', () {
      expect(item(target: 10).isFreeMode, isFalse);
      expect(item(target: 0).isFreeMode, isTrue);
      expect(item().isFreeMode, isTrue);
    });

    test('progress is clamped, and free mode fills only after counting', () {
      expect(item(count: 5, target: 10).progress, 0.5);
      expect(item(count: 10, target: 10).progress, 1);
      expect(item(count: 15, target: 10).progress, 1);
      expect(item(count: 5).progress, 1);
      expect(item(count: 1, target: 0).progress, 1);
      expect(item().progress, 0);
      expect(item(target: 0).progress, 0);
    });

    test('isCompleted is true at or above the target', () {
      expect(item(count: 10, target: 10).isCompleted, isTrue);
      expect(item(count: 11, target: 10).isCompleted, isTrue);
      expect(item(count: 9, target: 10).isCompleted, isFalse);
      expect(item(count: 100).isCompleted, isFalse);
    });

    test('remaining counts down for a target and up without one', () {
      expect(item(count: 3, target: 10).remaining, 7);
      expect(item(count: 3, target: 3).remaining, 0);
      expect(item(count: 30, target: 10).remaining, 0);
      expect(item(count: 5).remaining, 5);
    });

    test('canReset is true only after counting', () {
      expect(item(count: 0).canReset, isFalse);
      expect(item(count: 1).canReset, isTrue);
    });

    test('copyWith updates fields and preserves the rest', () {
      final original = item(count: 2, target: 10);

      final copy = original.copyWith(
        currentCount: 5,
        targetCount: () => null,
      );

      expect(copy.currentCount, 5);
      expect(copy.targetCount, isNull);
      expect(copy.id, original.id);
      expect(copy.text, original.text);
      expect(copy.lastUsedAt, original.lastUsedAt);
    });

    test('value equality and hashCode', () {
      expect(item(count: 2, target: 10), item(count: 2, target: 10));
      expect(
        item(count: 2, target: 10).hashCode,
        item(count: 2, target: 10).hashCode,
      );
      expect(item(count: 2, target: 10), isNot(item(count: 3, target: 10)));
    });
  });
}

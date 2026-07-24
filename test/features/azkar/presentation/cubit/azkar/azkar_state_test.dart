import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_state.dart';

void main() {
  const zikr1 = ZikrEntity(id: 1, text: 'سُبْحَانَ اللَّهِ', count: 3);
  const zikr2 = ZikrEntity(id: 2, text: 'الْحَمْدُ لِلَّهِ', count: 5);

  group('AzkarLoaded', () {
    test('isAllCompleted should return true if all zikrs completed', () {
      const state = AzkarLoaded(
        azkar: [zikr1, zikr2],
        counters: {1: 3, 2: 5},
        resolvedTitle: 'أذكار الصباح',
      );
      expect(state.isAllCompleted, true);
    });

    test('isAllCompleted should return false if any zikr not completed', () {
      const state = AzkarLoaded(
        azkar: [zikr1, zikr2],
        counters: {1: 3, 2: 2},
        resolvedTitle: 'أذكار الصباح',
      );
      expect(state.isAllCompleted, false);
    });

    test('hasStarted should return true if any counter > 0', () {
      const state = AzkarLoaded(
        azkar: [zikr1, zikr2],
        counters: {1: 1, 2: 0},
        resolvedTitle: 'أذكار الصباح',
      );
      expect(state.hasStarted, true);
    });

    test('hasStarted should return false if all counters are 0', () {
      const state = AzkarLoaded(
        azkar: [zikr1, zikr2],
        counters: {1: 0, 2: 0},
        resolvedTitle: 'أذكار الصباح',
      );
      expect(state.hasStarted, false);
    });

    group('nextIncompleteIndex()', () {
      test('should return index of first incomplete zikr after given index', () {
        const state = AzkarLoaded(
          azkar: [zikr1, zikr2],
          counters: {1: 3, 2: 0},
          resolvedTitle: 'أذكار الصباح',
        );
        expect(state.nextIncompleteIndex(0), 1);
      });

      test('should return null if all zikrs after index are complete', () {
        const state = AzkarLoaded(
          azkar: [zikr1, zikr2],
          counters: {1: 3, 2: 5},
          resolvedTitle: 'أذكار الصباح',
        );
        expect(state.nextIncompleteIndex(0), isNull);
      });
    });

    group('copyWith()', () {
      test('should return updated copy with new counters', () {
        const original = AzkarLoaded(
          azkar: [zikr1, zikr2],
          counters: {1: 0, 2: 0},
          resolvedTitle: 'أذكار الصباح',
        );
        final updated = original.copyWith(counters: {1: 1, 2: 0});

        expect(updated.counters[1], 1);
        expect(updated.azkar, original.azkar);
        expect(updated.resolvedTitle, original.resolvedTitle);
      });
    });
  });
}

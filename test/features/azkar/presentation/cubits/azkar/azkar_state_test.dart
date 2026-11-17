import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';

void main() {
  final azkar = [
    const ZikrEntity(id: 1, text: 'أ', count: 3),
    const ZikrEntity(id: 2, text: 'ب', count: 5),
  ];

  AzkarLoaded state({Map<int, int>? counters}) => AzkarLoaded(
    azkar: azkar,
    counters: counters ?? {1: 0, 2: 0},
    resolvedTitle: 'عنوان',
  );

  group('AzkarLoaded', () {
    test('firstIncompleteIndex finds the first unfinished zikr', () {
      expect(state().firstIncompleteIndex, 0);
      expect(state(counters: {1: 3, 2: 0}).firstIncompleteIndex, 1);
      expect(state(counters: {1: 3, 2: 5}).firstIncompleteIndex, isNull);
    });

    test('getProgressFor reports remaining, completed and canReset', () {
      final progress = state(counters: {1: 2, 2: 0}).getProgressFor(1);

      expect(progress.completedCount, 2);
      expect(progress.totalCount, 3);
      expect(progress.remaining, 1);
      expect(progress.isCompleted, isFalse);
      expect(progress.canReset, isTrue);
    });

    test('getProgressFor clamps remaining and marks completion', () {
      final progress = state(counters: {1: 5, 2: 0}).getProgressFor(1);

      expect(progress.remaining, 0);
      expect(progress.isCompleted, isTrue);
    });

    test('getProgressFor returns zeros for a missing id', () {
      final progress = state().getProgressFor(99);

      expect(progress.totalCount, 0);
      expect(progress.remaining, 0);
      expect(progress.isCompleted, isFalse);
      expect(progress.canReset, isFalse);
    });

    test('copyWith keeps the original values for omitted fields', () {
      final original = state();
      final copy = original.copyWith(resolvedTitle: 'جديد', isModified: true);

      expect(copy.resolvedTitle, 'جديد');
      expect(copy.isModified, isTrue);
      expect(copy.azkar, original.azkar);
      expect(copy.counters, original.counters);
      expect(copy.isCustom, original.isCustom);
    });
  });
}

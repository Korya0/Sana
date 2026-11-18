import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/zikr_progress.dart';

void main() {
  group('ZikrProgress', () {
    test('stores all provided values', () {
      const progress = ZikrProgress(
        completedCount: 2,
        totalCount: 33,
        remaining: 31,
        isCompleted: false,
        canReset: true,
      );

      expect(progress.completedCount, 2);
      expect(progress.totalCount, 33);
      expect(progress.remaining, 31);
      expect(progress.isCompleted, isFalse);
      expect(progress.canReset, isTrue);
    });

    test('represents a completed progress state', () {
      const progress = ZikrProgress(
        completedCount: 33,
        totalCount: 33,
        remaining: 0,
        isCompleted: true,
        canReset: true,
      );

      expect(progress.isCompleted, isTrue);
      expect(progress.remaining, 0);
      expect(progress.canReset, isTrue);
    });

    test('represents a fresh progress state', () {
      const progress = ZikrProgress(
        completedCount: 0,
        totalCount: 10,
        remaining: 10,
        isCompleted: false,
        canReset: false,
      );

      expect(progress.completedCount, 0);
      expect(progress.isCompleted, isFalse);
      expect(progress.canReset, isFalse);
    });
  });
}

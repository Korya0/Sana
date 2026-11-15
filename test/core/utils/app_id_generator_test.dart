import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/utils/app_id_generator.dart';

void main() {
  group('AppIdGenerator', () {
    test('builds an id from the prefix and the current microseconds', () {
      final generator = AppIdGenerator(
        clock: () => DateTime.fromMicrosecondsSinceEpoch(1700000000123456),
      );

      expect(generator.next(prefix: 'custom_'), 'custom_1700000000123456');
    });

    test('never repeats an id when the clock is frozen', () {
      final generator = AppIdGenerator(
        clock: () => DateTime.fromMicrosecondsSinceEpoch(1700000000000000),
      );

      final first = generator.next(prefix: 'custom_');
      final second = generator.next(prefix: 'custom_');

      expect(first, isNot(second));
    });

    test('skips ids that already exist', () {
      final generator = AppIdGenerator(
        clock: () => DateTime.fromMicrosecondsSinceEpoch(1700000000000000),
      );
      const existing = {'custom_1700000000000000'};

      final id = generator.next(prefix: 'custom_', existingIds: existing);

      expect(existing, isNot(contains(id)));
    });

    test('nextInt returns an id above the user-added threshold', () {
      final generator = AppIdGenerator(
        clock: () => DateTime.fromMicrosecondsSinceEpoch(1700000000000000),
      );

      expect(generator.nextInt(), greaterThan(100000));
    });

    test('nextInt never repeats when the clock is frozen', () {
      final generator = AppIdGenerator(
        clock: () => DateTime.fromMicrosecondsSinceEpoch(1700000000000000),
      );

      final first = generator.nextInt();
      final second = generator.nextInt();

      expect(first, isNot(second));
    });

    test('nextInt skips ids that already exist', () {
      final generator = AppIdGenerator(
        clock: () => DateTime.fromMicrosecondsSinceEpoch(1700000000000000),
      );
      final existing = {1700000000000000};

      final id = generator.nextInt(existingIds: existing);

      expect(existing, isNot(contains(id)));
    });
  });
}

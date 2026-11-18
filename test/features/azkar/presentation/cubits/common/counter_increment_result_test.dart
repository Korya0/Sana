import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';

void main() {
  group('CounterIncrementResult', () {
    test('CounterIncremented is a CounterIncrementResult', () {
      const result = CounterIncremented();
      expect(result, isA<CounterIncrementResult>());
    });

    test('CounterCompleted is a CounterIncrementResult', () {
      const result = CounterCompleted();
      expect(result, isA<CounterIncrementResult>());
    });

    test('CounterIgnored is a CounterIncrementResult', () {
      const result = CounterIgnored();
      expect(result, isA<CounterIncrementResult>());
    });

    test('result variants are distinguishable by type', () {
      const CounterIncrementResult incremented = CounterIncremented();
      const CounterIncrementResult completed = CounterCompleted();
      const CounterIncrementResult ignored = CounterIgnored();

      expect(incremented, isA<CounterIncremented>());
      expect(completed, isA<CounterCompleted>());
      expect(ignored, isA<CounterIgnored>());
      expect(incremented, isNot(isA<CounterCompleted>()));
      expect(completed, isNot(isA<CounterIgnored>()));
    });
  });
}

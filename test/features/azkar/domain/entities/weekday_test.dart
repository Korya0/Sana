import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/weekday.dart';

void main() {
  group('WeekDay', () {
    test('should contain 7 days from Monday (1) to Sunday (7)', () {
      expect(WeekDay.values.length, 7);
      expect(WeekDay.monday.value, 1);
      expect(WeekDay.tuesday.value, 2);
      expect(WeekDay.wednesday.value, 3);
      expect(WeekDay.thursday.value, 4);
      expect(WeekDay.friday.value, 5);
      expect(WeekDay.saturday.value, 6);
      expect(WeekDay.sunday.value, 7);
    });

    group('fromValue()', () {
      test('fromValue(1) should return monday', () {
        expect(WeekDay.fromValue(1), WeekDay.monday);
      });

      test('fromValue(7) should return sunday', () {
        expect(WeekDay.fromValue(7), WeekDay.sunday);
      });

      test('fromValue(99) should return monday (fallback)', () {
        expect(WeekDay.fromValue(99), WeekDay.monday);
      });
    });
  });
}

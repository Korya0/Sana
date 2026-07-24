import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';

void main() {
  group('NotificationTemplate', () {
    test('should contain morning, evening, night, wakeUp, general', () {
      expect(NotificationTemplate.values, contains(NotificationTemplate.morning));
      expect(NotificationTemplate.values, contains(NotificationTemplate.evening));
      expect(NotificationTemplate.values, contains(NotificationTemplate.night));
      expect(NotificationTemplate.values, contains(NotificationTemplate.wakeUp));
      expect(NotificationTemplate.values, contains(NotificationTemplate.general));
    });

    test('each template should have title and body', () {
      for (final template in NotificationTemplate.values) {
        expect(template.title, isNotEmpty);
        expect(template.body, isNotEmpty);
      }
    });

    group('fromAzkarId()', () {
      test('should return morning for morningAzkarId ("2")', () {
        expect(
          NotificationTemplate.fromAzkarId('2'),
          NotificationTemplate.morning,
        );
      });

      test('should return evening for eveningAzkarId ("3")', () {
        expect(
          NotificationTemplate.fromAzkarId('3'),
          NotificationTemplate.evening,
        );
      });

      test('should return night for sleepAzkarId ("4")', () {
        expect(
          NotificationTemplate.fromAzkarId('4'),
          NotificationTemplate.night,
        );
      });

      test('should return wakeUp for wakeUpAzkarId ("5")', () {
        expect(
          NotificationTemplate.fromAzkarId('5'),
          NotificationTemplate.wakeUp,
        );
      });

      test('should return general for any other id', () {
        expect(
          NotificationTemplate.fromAzkarId('1'),
          NotificationTemplate.general,
        );
        expect(
          NotificationTemplate.fromAzkarId('99'),
          NotificationTemplate.general,
        );
        expect(
          NotificationTemplate.fromAzkarId('unknown'),
          NotificationTemplate.general,
        );
      });
    });
  });
}

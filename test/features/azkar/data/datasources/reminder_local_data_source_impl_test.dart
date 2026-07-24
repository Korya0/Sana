import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/features/azkar/data/datasources/reminder_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';

class MockBox<T> extends Mock implements Box<T> {}

void main() {
  late MockBox<ReminderModel> mockBox;
  late ReminderLocalDataSourceImpl dataSource;

  setUp(() {
    mockBox = MockBox<ReminderModel>();
    dataSource = ReminderLocalDataSourceImpl(mockBox);
    registerFallbackValue(
      const ReminderModel(
        id: '', azkarId: '', time: '', repeatType: '', days: <int>[],
        isEnabled: false, timezone: '', template: '',
      ),
    );
  });

  test('boxName should return reminders_box', () {
    expect(ReminderLocalDataSourceImpl.boxName, 'reminders_box');
  });

  group('getReminders()', () {
    test('should return all reminders when azkarId is empty', () async {
      final reminders = <ReminderModel>[
        const ReminderModel(
          id: '1', azkarId: '2', time: '08:00', repeatType: 'daily',
          days: [], isEnabled: true, timezone: 'Cairo', template: 'morning',
        ),
        const ReminderModel(
          id: '2', azkarId: '3', time: '18:00', repeatType: 'daily',
          days: [], isEnabled: true, timezone: 'Cairo', template: 'evening',
        ),
      ];
      when(() => mockBox.values).thenReturn(reminders);

      final result = await dataSource.getReminders('');

      expect(result.length, 2);
    });

    test('should return filtered reminders by azkarId', () async {
      final reminders = <ReminderModel>[
        const ReminderModel(
          id: '1', azkarId: '2', time: '08:00', repeatType: 'daily',
          days: [], isEnabled: true, timezone: 'Cairo', template: 'morning',
        ),
        const ReminderModel(
          id: '2', azkarId: '3', time: '18:00', repeatType: 'daily',
          days: [], isEnabled: true, timezone: 'Cairo', template: 'evening',
        ),
      ];
      when(() => mockBox.values).thenReturn(reminders);

      final result = await dataSource.getReminders('2');

      expect(result.length, 1);
      expect(result.first.id, '1');
    });

    test('should return empty list if no reminders match azkarId', () async {
      when(() => mockBox.values).thenReturn(<ReminderModel>[]);

      final result = await dataSource.getReminders('99');

      expect(result.length, 0);
    });
  });

  group('getAllReminders()', () {
    test('should return all reminders in box', () async {
      final reminders = <ReminderModel>[
        const ReminderModel(
          id: '1', azkarId: '2', time: '08:00', repeatType: 'daily',
          days: [], isEnabled: true, timezone: 'Cairo', template: 'morning',
        ),
      ];
      when(() => mockBox.values).thenReturn(reminders);

      final result = await dataSource.getAllReminders();

      expect(result.length, 1);
    });

    test('should return empty list when box is empty', () async {
      when(() => mockBox.values).thenReturn(<ReminderModel>[]);

      final result = await dataSource.getAllReminders();

      expect(result.length, 0);
    });
  });

  group('saveReminder()', () {
    test('should save reminder with id as key', () async {
      const reminder = ReminderModel(
        id: '1', azkarId: '2', time: '08:00', repeatType: 'daily',
        days: [], isEnabled: true, timezone: 'Cairo', template: 'morning',
      );
      when(() => mockBox.put(any<String>(), any<ReminderModel>())).thenAnswer((_) async {});

      await dataSource.saveReminder(reminder);

      verify(() => mockBox.put('1', reminder)).called(1);
    });

    test('should overwrite existing reminder with same id', () async {
      const updatedReminder = ReminderModel(
        id: '1', azkarId: '2', time: '09:00', repeatType: 'daily',
        days: [], isEnabled: true, timezone: 'Cairo', template: 'morning',
      );
      when(() => mockBox.put(any<String>(), any<ReminderModel>())).thenAnswer((_) async {});

      await dataSource.saveReminder(updatedReminder);

      verify(() => mockBox.put('1', updatedReminder)).called(1);
    });
  });

  group('deleteReminder()', () {
    test('should delete reminder by id', () async {
      when(() => mockBox.delete(any<String>())).thenAnswer((_) async {});

      await dataSource.deleteReminder('1');

      verify(() => mockBox.delete('1')).called(1);
    });

    test('should not throw error if id does not exist', () async {
      when(() => mockBox.delete(any<String>())).thenAnswer((_) async {});

      await expectLater(
        dataSource.deleteReminder('nonexistent'),
        completes,
      );
    });
  });
}

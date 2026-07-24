import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';
import 'package:sana/features/azkar/data/repositories/reminder_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

class MockIReminderLocalDataSource extends Mock implements IReminderLocalDataSource {}

void main() {
  late ReminderRepositoryImpl repository;
  late MockIReminderLocalDataSource mockDataSource;

  const testModel = ReminderModel(
    id: '1',
    azkarId: '2',
    time: '08:00',
    repeatType: 'daily',
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: 'morning',
  );

  const testEntity = ReminderEntity(
    id: '1',
    azkarId: '2',
    time: '08:00',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  setUpAll(() {
    registerFallbackValue(const ReminderModel(
      id: '',
      azkarId: '',
      time: '',
      repeatType: '',
      days: [],
      isEnabled: false,
      timezone: '',
      template: '',
    ));
  });

  setUp(() {
    mockDataSource = MockIReminderLocalDataSource();
    repository = ReminderRepositoryImpl(mockDataSource);
  });

  group('getReminders()', () {
    test('should return Result.success with mapped ReminderEntities', () async {
      when(() => mockDataSource.getReminders('2')).thenAnswer((_) async => [testModel]);

      final result = await repository.getReminders('2');

      expect(result, isA<Success<List<ReminderEntity>>>());
      final data = (result as Success<List<ReminderEntity>>).data;
      expect(data.length, 1);
      expect(data.first.id, '1');
      expect(data.first.repeatType, RepeatType.daily);
    });

    test('should return Result.failure(ReminderFailure) on exception', () async {
      when(() => mockDataSource.getReminders(any())).thenThrow(Exception('DB error'));

      final result = await repository.getReminders('2');

      expect(result, isA<FailureResult<List<ReminderEntity>>>());
      expect((result as FailureResult).failure, isA<ReminderFailure>());
    });
  });

  group('getAllReminders()', () {
    test('should return Result.success with all reminders', () async {
      when(() => mockDataSource.getAllReminders()).thenAnswer((_) async => [testModel]);

      final result = await repository.getAllReminders();

      expect(result, isA<Success<List<ReminderEntity>>>());
      final data = (result as Success<List<ReminderEntity>>).data;
      expect(data.length, 1);
    });

    test('should return Result.failure(ReminderFailure) on exception', () async {
      when(() => mockDataSource.getAllReminders()).thenThrow(Exception('DB error'));

      final result = await repository.getAllReminders();

      expect(result, isA<FailureResult<List<ReminderEntity>>>());
      expect((result as FailureResult).failure, isA<ReminderFailure>());
    });
  });

  group('createReminder()', () {
    test('should save reminder mapped to model in data source', () async {
      when(() => mockDataSource.saveReminder(any())).thenAnswer((_) async {});

      final result = await repository.createReminder(testEntity);

      expect(result, isA<Success<void>>());
      verify(() => mockDataSource.saveReminder(any(
        that: isA<ReminderModel>().having((m) => m.id, 'id', '1'),
      ))).called(1);
    });

    test('should return Result.success(null) on success', () async {
      when(() => mockDataSource.saveReminder(any())).thenAnswer((_) async {});

      final result = await repository.createReminder(testEntity);

      expect(result, isA<Success<void>>());
    });

    test('should return Result.failure(ReminderFailure) on exception', () async {
      when(() => mockDataSource.saveReminder(any())).thenThrow(Exception('Save error'));

      final result = await repository.createReminder(testEntity);

      expect(result, isA<FailureResult<void>>());
      expect((result as FailureResult).failure, isA<ReminderFailure>());
    });
  });

  group('updateReminder()', () {
    test('should save updated reminder in data source', () async {
      when(() => mockDataSource.saveReminder(any())).thenAnswer((_) async {});

      final result = await repository.updateReminder(testEntity);

      expect(result, isA<Success<void>>());
      verify(() => mockDataSource.saveReminder(any())).called(1);
    });

    test('should return Result.success(null) on success', () async {
      when(() => mockDataSource.saveReminder(any())).thenAnswer((_) async {});

      final result = await repository.updateReminder(testEntity);

      expect(result, isA<Success<void>>());
    });

    test('should return Result.failure(ReminderFailure) on exception', () async {
      when(() => mockDataSource.saveReminder(any())).thenThrow(Exception('Update error'));

      final result = await repository.updateReminder(testEntity);

      expect(result, isA<FailureResult<void>>());
      expect((result as FailureResult).failure, isA<ReminderFailure>());
    });
  });

  group('deleteReminder()', () {
    test('should delete reminder from data source', () async {
      when(() => mockDataSource.deleteReminder('1')).thenAnswer((_) async {});

      final result = await repository.deleteReminder('1');

      expect(result, isA<Success<void>>());
      verify(() => mockDataSource.deleteReminder('1')).called(1);
    });

    test('should return Result.success(null) on success', () async {
      when(() => mockDataSource.deleteReminder('1')).thenAnswer((_) async {});

      final result = await repository.deleteReminder('1');

      expect(result, isA<Success<void>>());
    });

    test('should return Result.failure(ReminderFailure) on exception', () async {
      when(() => mockDataSource.deleteReminder(any())).thenThrow(Exception('Delete error'));

      final result = await repository.deleteReminder('1');

      expect(result, isA<FailureResult<void>>());
      expect((result as FailureResult).failure, isA<ReminderFailure>());
    });
  });

  group('toggleReminder()', () {
    test('should get reminder, toggle isEnabled, and save', () async {
      when(() => mockDataSource.getAllReminders()).thenAnswer((_) async => [testModel]);
      when(() => mockDataSource.saveReminder(any())).thenAnswer((_) async {});

      final result = await repository.toggleReminder('1', isEnabled: false);

      expect(result, isA<Success<ReminderEntity>>());
      final data = (result as Success<ReminderEntity>).data;
      expect(data.isEnabled, false);
    });

    test('should return failure if reminder not found', () async {
      when(() => mockDataSource.getAllReminders()).thenAnswer((_) async => <ReminderModel>[]);

      final result = await repository.toggleReminder('1', isEnabled: true);

      expect(result, isA<FailureResult<ReminderEntity>>());
      expect((result as FailureResult).failure, isA<ReminderFailure>());
    });

    test('should return Result.failure(ReminderFailure) on exception', () async {
      when(() => mockDataSource.getAllReminders()).thenThrow(Exception('DB error'));

      final result = await repository.toggleReminder('1', isEnabled: true);

      expect(result, isA<FailureResult<ReminderEntity>>());
      expect((result as FailureResult).failure, isA<ReminderFailure>());
    });
  });

  group('rescheduleAllActiveReminders()', () {
    test('should not throw exception (currently empty)', () async {
      await expectLater(
        repository.rescheduleAllActiveReminders(),
        completes,
      );
    });
  });
}

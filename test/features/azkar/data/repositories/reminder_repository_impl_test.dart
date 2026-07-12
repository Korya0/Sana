import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/azkar/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';
import 'package:sana/features/azkar/data/repositories/reminder_repository_impl.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';

class MockReminderLocalDataSource extends Mock
    implements ReminderLocalDataSource {}

class FakeReminderModel extends Fake implements ReminderModel {}

void main() {
  late ReminderRepositoryImpl repository;
  late MockReminderLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(FakeReminderModel());
  });

  setUp(() {
    mockDataSource = MockReminderLocalDataSource();
    repository = ReminderRepositoryImpl(mockDataSource);
  });

  const tAzkarId = '2';
  const tReminderModel = ReminderModel(
    id: '123',
    azkarId: '2',
    time: '07:00',
    repeatType: 'daily',
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: 'morning',
  );

  const tReminderEntity = ReminderEntity(
    id: '123',
    azkarId: '2',
    time: '07:00',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  group('getReminders', () {
    test(
      'should return mapped entities when data source is successful',
      () async {
        // Arrange
        when(
          () => mockDataSource.getReminders(tAzkarId),
        ).thenAnswer((_) async => [tReminderModel]);

        // Act
        final result = await repository.getReminders(tAzkarId);

        // Assert
        expect(result, isA<Success<List<ReminderEntity>>>());
        final data = (result as Success<List<ReminderEntity>>).data;
        expect(data.length, 1);
        expect(data.first.id, tReminderEntity.id);
        expect(data.first.time, tReminderEntity.time);
        verify(() => mockDataSource.getReminders(tAzkarId)).called(1);
      },
    );

    test('should return Failure when data source throws Exception', () async {
      // Arrange
      when(
        () => mockDataSource.getReminders(tAzkarId),
      ).thenThrow(Exception('Hive Error'));

      // Act
      final result = await repository.getReminders(tAzkarId);

      // Assert
      expect(
        result,
        const Result<List<ReminderEntity>>.failure(
          ReminderFailure(message: AppStrings.reminderLoadError),
        ),
      );
      verify(() => mockDataSource.getReminders(tAzkarId)).called(1);
    });
  });

  group('createReminder', () {
    test('should return Success when data source successfully saves', () async {
      // Arrange
      when(
        () => mockDataSource.saveReminder(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.createReminder(tReminderEntity);

      // Assert
      expect(result, const Result<void>.success(null));
      verify(() => mockDataSource.saveReminder(any())).called(1);
    });

    test(
      'should return Failure when data source throws Exception during save',
      () async {
        // Arrange
        when(() => mockDataSource.saveReminder(any())).thenThrow(Exception());

        // Act
        final result = await repository.createReminder(tReminderEntity);

        // Assert
        expect(
          result,
          const Result<void>.failure(
            ReminderFailure(message: AppStrings.reminderSaveError),
          ),
        );
        verify(() => mockDataSource.saveReminder(any())).called(1);
      },
    );
  });

  group('toggleReminder', () {
    test('should update isEnabled, save, and return updated entity', () async {
      // Arrange
      when(
        () => mockDataSource.getAllReminders(),
      ).thenAnswer((_) async => [tReminderModel]);
      when(
        () => mockDataSource.saveReminder(any()),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.toggleReminder('123', isEnabled: false);

      // Assert
      expect(result, isA<Success<ReminderEntity>>());
      final data = (result as Success<ReminderEntity>).data;
      expect(data.isEnabled, false);
      verify(() => mockDataSource.getAllReminders()).called(1);
      verify(() => mockDataSource.saveReminder(any())).called(1);
    });

    test('should return Failure when reminder is not found', () async {
      // Arrange
      when(() => mockDataSource.getAllReminders()).thenAnswer((_) async => []);

      // Act
      final result = await repository.toggleReminder('123', isEnabled: false);

      // Assert
      expect(
        result,
        const Result<ReminderEntity>.failure(
          ReminderFailure(message: AppStrings.reminderNotFound),
        ),
      );
      verify(() => mockDataSource.getAllReminders()).called(1);
      verifyNever(() => mockDataSource.saveReminder(any()));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/use_cases/create_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/delete_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_reminders_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/reminder_use_cases.dart';
import 'package:sana/features/azkar/domain/use_cases/toggle_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/update_reminder_use_case.dart';

class MockGetRemindersUseCase extends Mock implements GetRemindersUseCase {}
class MockCreateReminderUseCase extends Mock implements CreateReminderUseCase {}
class MockUpdateReminderUseCase extends Mock implements UpdateReminderUseCase {}
class MockDeleteReminderUseCase extends Mock implements DeleteReminderUseCase {}
class MockToggleReminderUseCase extends Mock implements ToggleReminderUseCase {}

void main() {
  late ReminderUseCases useCases;
  late MockGetRemindersUseCase mockGetReminders;
  late MockCreateReminderUseCase mockCreateReminder;
  late MockUpdateReminderUseCase mockUpdateReminder;
  late MockDeleteReminderUseCase mockDeleteReminder;
  late MockToggleReminderUseCase mockToggleReminder;

  setUp(() {
    mockGetReminders = MockGetRemindersUseCase();
    mockCreateReminder = MockCreateReminderUseCase();
    mockUpdateReminder = MockUpdateReminderUseCase();
    mockDeleteReminder = MockDeleteReminderUseCase();
    mockToggleReminder = MockToggleReminderUseCase();

    useCases = ReminderUseCases(
      getReminders: mockGetReminders,
      createReminder: mockCreateReminder,
      updateReminder: mockUpdateReminder,
      deleteReminder: mockDeleteReminder,
      toggleReminder: mockToggleReminder,
    );
  });

  test('getReminders should delegate to GetRemindersUseCase', () async {
    when(() => mockGetReminders('2')).thenAnswer(
      (_) async => const Result.success(<ReminderEntity>[]),
    );

    final result = await useCases.getReminders('2');

    expect(result, isA<Success<List<ReminderEntity>>>());
    verify(() => mockGetReminders('2')).called(1);
  });

  test('createReminder should delegate to CreateReminderUseCase', () async {
    const params = CreateReminderParams(
      azkarId: '2',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: [],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );
    when(() => mockCreateReminder(params)).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCases.createReminder(params);

    expect(result, isA<Success<void>>());
    verify(() => mockCreateReminder(params)).called(1);
  });

  test('updateReminder should delegate to UpdateReminderUseCase', () async {
    const reminder = ReminderEntity(
      id: '1',
      azkarId: '2',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: [],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );
    when(() => mockUpdateReminder(reminder)).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCases.updateReminder(reminder);

    expect(result, isA<Success<void>>());
    verify(() => mockUpdateReminder(reminder)).called(1);
  });

  test('deleteReminder should delegate to DeleteReminderUseCase', () async {
    when(() => mockDeleteReminder('1')).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCases.deleteReminder('1');

    expect(result, isA<Success<void>>());
    verify(() => mockDeleteReminder('1')).called(1);
  });

  test('toggleReminder should delegate to ToggleReminderUseCase', () async {
    when(() => mockToggleReminder('1', isEnabled: true)).thenAnswer(
      (_) async => const Result.success(null),
    );

    final result = await useCases.toggleReminder('1', isEnabled: true);

    expect(result, isA<Success<void>>());
    verify(() => mockToggleReminder('1', isEnabled: true)).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/network/result.dart';
import 'package:sana/core/services/notification/notification_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/use_cases/reminder_use_cases.dart';
import 'package:sana/features/azkar/presentation/cubits/reminder/reminder_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reminder/reminder_state.dart';

class MockReminderUseCases extends Mock implements ReminderUseCases {}
class MockAppPermissionsManager extends Mock implements AppPermissionsManager {}
class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late ReminderCubit cubit;
  late MockReminderUseCases mockUseCases;
  late MockAppPermissionsManager mockPermissions;
  late MockNotificationService mockNotificationService;

  const testReminder = ReminderEntity(
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
    registerFallbackValue(const ReminderEntity(
      id: '',
      azkarId: '',
      time: '',
      repeatType: RepeatType.once,
      days: [],
      isEnabled: false,
      timezone: '',
      template: NotificationTemplate.general,
    ));
    registerFallbackValue(const CreateReminderParams(
      azkarId: '',
      time: '',
      repeatType: RepeatType.once,
      days: [],
      isEnabled: false,
      timezone: '',
      template: NotificationTemplate.general,
    ));
  });

  setUp(() {
    mockUseCases = MockReminderUseCases();
    mockPermissions = MockAppPermissionsManager();
    mockNotificationService = MockNotificationService();
    cubit = ReminderCubit(
      reminderUseCases: mockUseCases,
      permissionsManager: mockPermissions,
      notificationService: mockNotificationService,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state should be ReminderInitial', () {
    expect(cubit.state, isA<ReminderInitial>());
  });

  group('requestPermissions()', () {
    test('should request notification permission', () async {
      when(() => mockPermissions.requestNotificationPermission())
          .thenAnswer((_) async => true);
      when(() => mockNotificationService.canScheduleExactAlarms())
          .thenAnswer((_) async => true);

      final result = await cubit.requestPermissions();

      verify(() => mockPermissions.requestNotificationPermission()).called(1);
      expect(result, true);
    });

    test('should return false if notification permission denied', () async {
      when(() => mockPermissions.requestNotificationPermission())
          .thenAnswer((_) async => false);

      final result = await cubit.requestPermissions();

      expect(result, false);
    });

    test('should check canScheduleExactAlarms if permission granted', () async {
      when(() => mockPermissions.requestNotificationPermission())
          .thenAnswer((_) async => true);
      when(() => mockNotificationService.canScheduleExactAlarms())
          .thenAnswer((_) async => true);

      await cubit.requestPermissions();

      verify(() => mockNotificationService.canScheduleExactAlarms()).called(1);
    });
  });

  group('openSettings()', () {
    test('should call permissionsManager.openSettings()', () async {
      when(() => mockPermissions.openSettings()).thenAnswer((_) async => true);

      await cubit.openSettings();

      verify(() => mockPermissions.openSettings()).called(1);
    });
  });

  group('loadReminders()', () {
    test('should emit ReminderLoading then ReminderLoaded on success', () async {
      when(() => mockUseCases.getReminders('2')).thenAnswer(
        (_) async => const Result.success([testReminder]),
      );

      await cubit.loadReminders('2');

      expect(cubit.state, isA<ReminderLoaded>());
      expect((cubit.state as ReminderLoaded).reminders.length, 1);
    });

    test('should emit ReminderError on failure', () async {
      when(() => mockUseCases.getReminders(any())).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Error loading'),
        ),
      );

      await cubit.loadReminders('2');

      expect(cubit.state, isA<ReminderError>());
      expect((cubit.state as ReminderError).message, 'Error loading');
    });
  });

  group('createReminder()', () {
    test('should call use case and reload reminders on success', () async {
      when(() => mockUseCases.createReminder(any())).thenAnswer(
        (_) async => const Result.success(null),
      );
      when(() => mockUseCases.getReminders('2')).thenAnswer(
        (_) async => const Result.success([testReminder]),
      );

      await cubit.createReminder(testReminder);

      verify(() => mockUseCases.createReminder(any(
        that: isA<CreateReminderParams>(),
      ))).called(1);
      // Should reload after success
      verify(() => mockUseCases.getReminders('2')).called(1);
    });

    test('should emit ReminderError if creation fails', () async {
      when(() => mockUseCases.createReminder(any())).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Create error'),
        ),
      );

      await cubit.createReminder(testReminder);

      expect(cubit.state, isA<ReminderError>());
      // Should NOT reload on failure
      verifyNever(() => mockUseCases.getReminders(any()));
    });
  });

  group('updateReminder()', () {
    test('should call use case and reload reminders on success', () async {
      when(() => mockUseCases.updateReminder(any())).thenAnswer(
        (_) async => const Result.success(null),
      );
      when(() => mockUseCases.getReminders('2')).thenAnswer(
        (_) async => const Result.success([testReminder]),
      );

      await cubit.updateReminder(testReminder);

      verify(() => mockUseCases.updateReminder(testReminder)).called(1);
      verify(() => mockUseCases.getReminders('2')).called(1);
    });

    test('should emit ReminderError if update fails', () async {
      when(() => mockUseCases.updateReminder(any())).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Update error'),
        ),
      );

      await cubit.updateReminder(testReminder);

      expect(cubit.state, isA<ReminderError>());
    });
  });

  group('deleteReminder()', () {
    test('should call use case and reload reminders on success', () async {
      when(() => mockUseCases.deleteReminder('1')).thenAnswer(
        (_) async => const Result.success(null),
      );
      when(() => mockUseCases.getReminders('2')).thenAnswer(
        (_) async => const Result.success(<ReminderEntity>[]),
      );

      await cubit.deleteReminder('1', '2');

      verify(() => mockUseCases.deleteReminder('1')).called(1);
      verify(() => mockUseCases.getReminders('2')).called(1);
    });

    test('should emit ReminderError if delete fails', () async {
      when(() => mockUseCases.deleteReminder(any())).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Delete error'),
        ),
      );

      await cubit.deleteReminder('1', '2');

      expect(cubit.state, isA<ReminderError>());
    });
  });

  group('toggleReminder()', () {
    test('should call use case and reload reminders on success', () async {
      when(() => mockUseCases.toggleReminder('1', isEnabled: true)).thenAnswer(
        (_) async => const Result.success(null),
      );
      when(() => mockUseCases.getReminders('2')).thenAnswer(
        (_) async => const Result.success([testReminder]),
      );

      await cubit.toggleReminder('1', '2', isEnabled: true);

      verify(() => mockUseCases.toggleReminder('1', isEnabled: true)).called(1);
      verify(() => mockUseCases.getReminders('2')).called(1);
    });

    test('should emit ReminderError if toggle fails', () async {
      when(() => mockUseCases.toggleReminder(any(), isEnabled: any(named: 'isEnabled'))).thenAnswer(
        (_) async => const Result.failure(
          CacheFailure(message: 'Toggle error'),
        ),
      );

      await cubit.toggleReminder('1', '2', isEnabled: true);

      expect(cubit.state, isA<ReminderError>());
    });
  });
}

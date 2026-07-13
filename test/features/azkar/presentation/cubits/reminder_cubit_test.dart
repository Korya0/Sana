import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/params/create_reminder_params.dart';
import 'package:sana/features/azkar/domain/usecases/reminder_use_cases.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_state.dart';

class MockReminderUseCases extends Mock implements ReminderUseCases {}

class MockAppPermissionsManager extends Mock
    implements IAppPermissionsManager {}

class MockNotificationService extends Mock implements INotificationService {}

class FakeCreateReminderParams extends Fake implements CreateReminderParams {}

void main() {
  late ReminderCubit cubit;
  late MockReminderUseCases mockReminderUseCases;
  late MockAppPermissionsManager mockPermissionsManager;
  late MockNotificationService mockNotificationService;

  setUpAll(() {
    registerFallbackValue(FakeCreateReminderParams());
  });

  setUp(() {
    mockReminderUseCases = MockReminderUseCases();
    mockPermissionsManager = MockAppPermissionsManager();
    mockNotificationService = MockNotificationService();

    cubit = ReminderCubit(
      reminderUseCases: mockReminderUseCases,
      permissionsManager: mockPermissionsManager,
      notificationService: mockNotificationService,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  const tAzkarId = '2';
  const tReminder = ReminderEntity(
    id: '123',
    azkarId: '2',
    time: '07:00',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: true,
    timezone: 'Africa/Cairo',
    template: NotificationTemplate.morning,
  );

  group('requestPermissions', () {
    test('should return true when both permissions are granted', () async {
      when(
        () => mockPermissionsManager.requestNotificationPermission(),
      ).thenAnswer((_) async => true);
      when(
        () => mockNotificationService.canScheduleExactAlarms(),
      ).thenAnswer((_) async => true);

      final result = await cubit.requestPermissions();
      expect(result, true);
    });

    test(
      'should return false when notification permission is denied',
      () async {
        when(
          () => mockPermissionsManager.requestNotificationPermission(),
        ).thenAnswer((_) async => false);

        final result = await cubit.requestPermissions();
        expect(result, false);
        verifyNever(() => mockNotificationService.canScheduleExactAlarms());
      },
    );
  });

  group('loadReminders', () {
    blocTest<ReminderCubit, ReminderState>(
      'emits [ReminderLoading, ReminderLoaded] when successful',
      build: () {
        when(
          () => mockReminderUseCases.getReminders(tAzkarId),
        ).thenAnswer((_) async => const Result.success([tReminder]));
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadReminders(tAzkarId);
      },
      expect: () => [
        const ReminderLoading(),
        const ReminderLoaded([tReminder]),
      ],
    );

    blocTest<ReminderCubit, ReminderState>(
      'emits [ReminderLoading, ReminderError] when failure occurs',
      build: () {
        when(() => mockReminderUseCases.getReminders(tAzkarId)).thenAnswer(
          (_) async => const Result.failure(CacheFailure(message: 'Error')),
        );
        return cubit;
      },
      act: (cubit) async {
        await cubit.loadReminders(tAzkarId);
      },
      expect: () => [
        const ReminderLoading(),
        const ReminderError('Error'),
      ],
    );
  });

  group('createReminder', () {
    blocTest<ReminderCubit, ReminderState>(
      'emits [ReminderLoading, ReminderLoaded] when creation succeeds',
      build: () {
        when(
          () => mockReminderUseCases.createReminder(any()),
        ).thenAnswer((_) async => const Result.success(null));
        when(
          () => mockReminderUseCases.getReminders(tReminder.azkarId),
        ).thenAnswer((_) async => const Result.success([tReminder]));
        return cubit;
      },
      act: (cubit) async {
        await cubit.createReminder(tReminder);
      },
      expect: () => [
        const ReminderLoading(),
        const ReminderLoaded([tReminder]),
      ],
    );

    blocTest<ReminderCubit, ReminderState>(
      'emits [ReminderError] when creation fails (e.g. limit reached)',
      build: () {
        when(() => mockReminderUseCases.createReminder(any())).thenAnswer(
          (_) async =>
              const Result.failure(ReminderFailure(message: 'Already exists')),
        );
        return cubit;
      },
      act: (cubit) async {
        await cubit.createReminder(tReminder);
      },
      expect: () => [
        const ReminderError('Already exists'),
      ],
    );
  });
}

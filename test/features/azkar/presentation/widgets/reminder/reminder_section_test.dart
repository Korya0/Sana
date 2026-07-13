import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_state.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_empty_view.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_section.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_tile.dart';

class MockReminderCubit extends MockCubit<ReminderState>
    implements ReminderCubit {}

void main() {
  late MockReminderCubit mockCubit;

  setUp(() {
    mockCubit = MockReminderCubit();
    when(() => mockCubit.loadReminders(any())).thenAnswer((_) async {});
    GetIt.I.registerSingleton<ReminderCubit>(mockCubit);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: widget,
      ),
    );
  }

  testWidgets(
    'should render SizedBox.shrink when azkarId is not in allowed list',
    (tester) async {
      when(() => mockCubit.state).thenReturn(const ReminderInitial());

      await tester.pumpWidget(
        buildTestableWidget(const ReminderSection(azkarId: '99')),
      ); // 99 is not allowed

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.text('التنبيهات'), findsNothing);
    },
  );

  testWidgets(
    'should show ReminderEmptyView when state is ReminderLoaded with empty list',
    (tester) async {
      when(() => mockCubit.state).thenReturn(const ReminderLoaded([]));

      await tester.pumpWidget(
        buildTestableWidget(const ReminderSection(azkarId: '2')),
      ); // 2 is Morning (Allowed)
      await tester.pumpAndSettle();

      expect(find.byType(ReminderEmptyView), findsOneWidget);
      expect(find.byType(ReminderTile), findsNothing);
    },
  );

  testWidgets(
    'should show ReminderTile and hide Add Button when state is ReminderLoaded with 1 reminder',
    (tester) async {
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

      when(() => mockCubit.state).thenReturn(const ReminderLoaded([tReminder]));

      await tester.pumpWidget(
        buildTestableWidget(const ReminderSection(azkarId: '2')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ReminderTile), findsOneWidget);
      expect(find.byType(ReminderEmptyView), findsNothing);
    },
  );
}

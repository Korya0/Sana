import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/azkar/presentation/cubits/reminder/reminder_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_dialog.dart';

class MockReminderCubit extends Mock implements ReminderCubit {}

void main() {
  late MockReminderCubit mockCubit;

  setUp(() {
    mockCubit = MockReminderCubit();
  });

  Widget buildTestableWidget(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ReminderCubit>.value(
          value: mockCubit,
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => widget,
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('should render time picker and save button when opened', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestableWidget(const ReminderDialog(azkarId: '2')),
    );

    // Tap to open the bottom sheet
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify Time Display exists
    expect(find.byType(InkWell), findsWidgets);

    // Verify Repeat label exists
    expect(find.text(AppStrings.repeat), findsOneWidget);

    // Verify Save Button exists
    expect(find.text(AppStrings.saveChanges), findsOneWidget);
  });
}

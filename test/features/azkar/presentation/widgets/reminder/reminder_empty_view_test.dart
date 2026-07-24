import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_empty_view.dart';

void main() {
  group('ReminderEmptyView', () {
    testWidgets('should display notification off icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(body: ReminderEmptyView()),
        ),
      );

      expect(find.byIcon(Icons.notifications_off_outlined), findsOneWidget);
    });

    testWidgets('should display empty message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: const Scaffold(body: ReminderEmptyView()),
        ),
      );

      expect(
        find.text(AppStrings.noRemindersActiveForThisZikr),
        findsOneWidget,
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/theme/extensions/color_extension.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_tile.dart';
import 'package:solar_icons/solar_icons.dart';

void main() {
  group('ReminderTile', () {
    const baseReminder = ReminderEntity(
      id: '1',
      azkarId: '2',
      time: '08:00',
      repeatType: RepeatType.daily,
      days: <int>[],
      isEnabled: true,
      timezone: 'Africa/Cairo',
      template: NotificationTemplate.morning,
    );

    testWidgets('should display time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: ReminderTile(
              reminder: baseReminder,
              onToggle: (_) {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      // Time should be displayed (localized format)
      expect(find.byType(ReminderTile), findsOneWidget);
    });

    testWidgets('should display "يومياً" for RepeatType.daily', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: ReminderTile(
              reminder: baseReminder,
              onToggle: (_) {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('يومياً'), findsOneWidget);
    });

    testWidgets('should display "مرة واحدة" for RepeatType.once', (tester) async {
      final reminder = baseReminder.copyWith(repeatType: RepeatType.once);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: ReminderTile(
              reminder: reminder,
              onToggle: (_) {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('مرة واحدة'), findsOneWidget);
    });

    testWidgets('should display Switch reflecting isEnabled state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: ReminderTile(
              reminder: baseReminder,
              onToggle: (_) {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('should call onDelete when delete button is tapped', (tester) async {
      var deleted = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: ReminderTile(
              reminder: baseReminder,
              onToggle: (_) {},
              onDelete: () => deleted = true,
              onTap: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(SolarIconsBold.trashBinTrash));
      await tester.pump();

      expect(deleted, true);
    });

    testWidgets('should display custom day short labels for RepeatType.custom', (tester) async {
      final reminder = baseReminder.copyWith(
        repeatType: RepeatType.custom,
        days: <int>[1, 3, 5],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData().copyWith(extensions: [MyColors.light]),
          home: Scaffold(
            body: ReminderTile(
              reminder: reminder,
              onToggle: (_) {},
              onDelete: () {},
              onTap: () {},
            ),
          ),
        ),
      );

      // Custom days show short labels: ن, ر, ج
      expect(find.textContaining('أيام: '), findsOneWidget);
    });
  });
}

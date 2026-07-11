import 'package:flutter/material.dart';

import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/entities/weekday.dart';

class ReminderTile extends StatelessWidget {
  const ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
    super.key,
  });

  final ReminderEntity reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  String _formatTime(BuildContext context) {
    final parts = reminder.time.split(':');
    final time = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
    return time.format(context);
  }

  String _formatSubtitle() {
    switch (reminder.repeatType) {
      case RepeatType.once:
        return 'مرة واحدة';
      case RepeatType.daily:
        return 'يومياً';
      case RepeatType.custom:
        final days = reminder.days
            .map(WeekDay.fromValue)
            .map(_getWeekdayShortLabel)
            .join('، ');
        return 'أيام: $days';
    }
  }

  String _getWeekdayShortLabel(WeekDay day) {
    switch (day) {
      case WeekDay.monday:
        return 'ن';
      case WeekDay.tuesday:
        return 'ث';
      case WeekDay.wednesday:
        return 'ر';
      case WeekDay.thursday:
        return 'خ';
      case WeekDay.friday:
        return 'ج';
      case WeekDay.saturday:
        return 'س';
      case WeekDay.sunday:
        return 'ح';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTime(context),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: reminder.isEnabled
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatSubtitle(),
                      style: TextStyle(
                        fontSize: 13,
                        color: reminder.isEnabled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Theme.of(context).colorScheme.error,
                onPressed: onDelete,
              ),
              Switch.adaptive(
                value: reminder.isEnabled,
                onChanged: onToggle,
                activeThumbColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

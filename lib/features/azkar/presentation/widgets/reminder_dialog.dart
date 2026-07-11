import 'package:flutter/material.dart';

import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/validators/reminder_validator.dart';
import 'package:sana/features/azkar/presentation/widgets/repeat_selector.dart';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog({
    required this.azkarId,
    this.existingReminder,
    super.key,
  });

  final String azkarId;
  final ReminderEntity? existingReminder;

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  late TimeOfDay _selectedTime;
  late RepeatType _repeatType;
  late List<int> _days;

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      final parts = widget.existingReminder!.time.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
      _repeatType = widget.existingReminder!.repeatType;
      _days = List.from(widget.existingReminder!.days);
    } else {
      _selectedTime = TimeOfDay.now();
      _repeatType = RepeatType.daily;
      _days = [];
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _save() {
    final timeString =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    // Validate using centralized validator
    final validation = ReminderValidator.validate(
      time: timeString,
      repeatType: _repeatType,
      days: _days,
    );
    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validation.errorMessage!)),
      );
      return;
    }

    final reminder = ReminderEntity(
      id: widget.existingReminder?.id ?? '',
      azkarId: widget.azkarId,
      time: timeString,
      repeatType: _repeatType,
      days: _days,
      isEnabled: widget.existingReminder?.isEnabled ?? true,
      timezone: 'Local',
      template: NotificationTemplate.fromAzkarId(widget.azkarId),
    );

    Navigator.of(context).pop(reminder);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingReminder == null ? 'إضافة تذكير' : 'تعديل التذكير'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('وقت التذكير'),
              trailing: TextButton(
                onPressed: _selectTime,
                child: Text(
                  _selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            RepeatSelector(
              initialRepeatType: _repeatType,
              initialDays: _days,
              onChanged: (type, days) {
                setState(() {
                  _repeatType = type;
                  _days = List.from(days);
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/validators/reminder_validator.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/repeat_selector.dart';

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
      _selectedTime = TimeOfDay(
        hour: widget.existingReminder!.hour,
        minute: widget.existingReminder!.minute,
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
      AppToast.show(
        context,
        validation.errorMessage!,
        type: AppToastType.error,
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

    AppNavigator.pop(context, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              widget.existingReminder == null ? AppStrings.addReminder : AppStrings.editReminder,
              style: AppTextStyles.font20W700(context),
            ),
          ),
          const AppGap.h(AppSpacing.v16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.tapTimeToChange,
                        style: AppTextStyles.font12W500(context).copyWith(
                          color: context.color.textSecondary,
                        ),
                      ),
                      const AppGap.h(AppSpacing.v8),
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: _selectTime,
                          child: AppSectionCard(
                            padding: const EdgeInsets.all(AppSpacing.v12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.reminderTime,
                                  style: AppTextStyles.font12W500(context).copyWith(
                                    color: context.color.textSecondary,
                                  ),
                                ),
                                const AppGap.h(AppSpacing.v4),
                                Text(
                                  _selectedTime.format(context),
                                  style: AppTextStyles.font20W700(context).copyWith(
                                    color: context.color.textAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const AppGap.h(AppSpacing.v8),
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
          ),
          const AppGap.h(AppSpacing.v24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: AppSecondaryButton(
                  text: AppStrings.cancel,
                  onPressed: () => AppNavigator.pop(context),
                ),
              ),
              const AppGap.w(AppSpacing.v12),
              Expanded(
                child: AppPrimaryButton(
                  text: AppStrings.saveChanges,
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

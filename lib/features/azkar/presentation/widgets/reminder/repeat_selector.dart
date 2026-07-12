import 'package:sana/core/common/common.dart';
import 'package:flutter/material.dart';

import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'package:sana/features/azkar/domain/entities/weekday.dart';

class RepeatSelector extends StatefulWidget {
  const RepeatSelector({
    required this.initialRepeatType,
    required this.initialDays,
    required this.onChanged,
    super.key,
  });

  final RepeatType initialRepeatType;
  final List<int> initialDays;
  final void Function(RepeatType, List<int>) onChanged;

  @override
  State<RepeatSelector> createState() => _RepeatSelectorState();
}

class _RepeatSelectorState extends State<RepeatSelector> {
  late RepeatType _selectedRepeat;
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedRepeat = widget.initialRepeatType;
    _selectedDays = List.from(widget.initialDays);
  }

  void _onRepeatTypeChanged(RepeatType? type) {
    if (type == null) return;
    setState(() {
      _selectedRepeat = type;
      if (type != RepeatType.custom) {
        _selectedDays.clear();
      }
    });
    widget.onChanged(_selectedRepeat, _selectedDays);
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
    widget.onChanged(_selectedRepeat, _selectedDays);
  }

  String _getRepeatTypeLabel(RepeatType type) {
    switch (type) {
      case RepeatType.once:
        return AppStrings.repeatOnce;
      case RepeatType.daily:
        return AppStrings.repeatDaily;
      case RepeatType.custom:
        return AppStrings.repeatCustom;
    }
  }

  String _getWeekdayLabel(WeekDay day) {
    switch (day) {
      case WeekDay.monday:
        return AppStrings.monday;
      case WeekDay.tuesday:
        return AppStrings.tuesday;
      case WeekDay.wednesday:
        return AppStrings.wednesday;
      case WeekDay.thursday:
        return AppStrings.thursday;
      case WeekDay.friday:
        return AppStrings.friday;
      case WeekDay.saturday:
        return AppStrings.saturday;
      case WeekDay.sunday:
        return AppStrings.sunday;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.repeat,
          style: AppTextStyles.font16W700(context),
        ),
        const AppGap.h(AppSpacing.v8),
        Wrap(
          spacing: AppSpacing.v8,
          children: RepeatType.values.map((type) {
            final isSelected = _selectedRepeat == type;
            return ChoiceChip(
              label: Text(_getRepeatTypeLabel(type)),
              selected: isSelected,
              onSelected: (_) => _onRepeatTypeChanged(type),
              selectedColor: context.color.primary.withValues(alpha: 0.2),
              labelStyle: AppTextStyles.font14W500(context).copyWith(
                    color: isSelected ? context.color.primary : context.color.textPrimary,
                  ),
            );
          }).toList(),
        ),
        if (_selectedRepeat == RepeatType.custom) ...[
          const AppGap.h(AppSpacing.v16),
          Text(
            AppStrings.days,
            style: AppTextStyles.font16W700(context),
          ),
          const AppGap.h(AppSpacing.v8),
          Wrap(
            spacing: AppSpacing.v8,
            runSpacing: AppSpacing.v8,
            children: WeekDay.values.map((day) {
              final isSelected = _selectedDays.contains(day.value);
              return FilterChip(
                label: Text(_getWeekdayLabel(day)),
                selected: isSelected,
                onSelected: (_) => _toggleDay(day.value),
                selectedColor: context.color.primary.withValues(alpha: 0.2),
                checkmarkColor: context.color.primary,
                labelStyle: AppTextStyles.font14W500(context).copyWith(
                      color: isSelected ? context.color.primary : context.color.textPrimary,
                    ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

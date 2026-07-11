import 'package:flutter/material.dart';

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
        return 'مرة واحدة';
      case RepeatType.daily:
        return 'يومياً';
      case RepeatType.custom:
        return 'أيام مخصصة';
    }
  }

  String _getWeekdayLabel(WeekDay day) {
    switch (day) {
      case WeekDay.monday:
        return 'الإثنين';
      case WeekDay.tuesday:
        return 'الثلاثاء';
      case WeekDay.wednesday:
        return 'الأربعاء';
      case WeekDay.thursday:
        return 'الخميس';
      case WeekDay.friday:
        return 'الجمعة';
      case WeekDay.saturday:
        return 'السبت';
      case WeekDay.sunday:
        return 'الأحد';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'التكرار',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: RepeatType.values.map((type) {
            final isSelected = _selectedRepeat == type;
            return ChoiceChip(
              label: Text(_getRepeatTypeLabel(type)),
              selected: isSelected,
              onSelected: (_) => _onRepeatTypeChanged(type),
              selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.primary : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            );
          }).toList(),
        ),
        if (_selectedRepeat == RepeatType.custom) ...[
          const SizedBox(height: 16),
          const Text(
            'الأيام',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: WeekDay.values.map((day) {
              final isSelected = _selectedDays.contains(day.value);
              return FilterChip(
                label: Text(_getWeekdayLabel(day)),
                selected: isSelected,
                onSelected: (_) => _toggleDay(day.value),
                selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

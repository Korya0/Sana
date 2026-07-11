import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/reminder/reminder_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reminder/reminder_state.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder_dialog.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder_empty_view.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder_tile.dart';

class ReminderSection extends StatelessWidget {
  const ReminderSection({
    required this.azkarId,
    super.key,
  });

  final String azkarId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = GetIt.I<ReminderCubit>();
        unawaited(cubit.loadReminders(azkarId));
        return cubit;
      },
      child: _ReminderSectionContent(azkarId: azkarId),
    );
  }
}

class _ReminderSectionContent extends StatelessWidget {
  const _ReminderSectionContent({required this.azkarId});

  final String azkarId;

  Future<void> _showReminderDialog(
    BuildContext context, [
    ReminderEntity? existingReminder,
  ]) async {
    final cubit = context.read<ReminderCubit>();
    final result = await showDialog<ReminderEntity>(
      context: context,
      builder: (context) => ReminderDialog(
        azkarId: azkarId,
        existingReminder: existingReminder,
      ),
    );

    if (result != null) {
      if (existingReminder != null) {
        await cubit.updateReminder(result);
      } else {
        await cubit.createReminder(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'التذكيرات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showReminderDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('إضافة'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocConsumer<ReminderCubit, ReminderState>(
          listener: (context, state) {
            if (state is ReminderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ReminderLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReminderLoaded) {
              final reminders = state.reminders;
              if (reminders.isEmpty) {
                return const ReminderEmptyView();
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reminders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return ReminderTile(
                    reminder: reminder,
                    onToggle: (isEnabled) {
                      unawaited(context.read<ReminderCubit>().toggleReminder(
                            reminder.id,
                            azkarId,
                            isEnabled: isEnabled,
                          ));
                    },
                    onDelete: () {
                      unawaited(context
                          .read<ReminderCubit>()
                          .deleteReminder(reminder.id, azkarId));
                    },
                    onTap: () => _showReminderDialog(context, reminder),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

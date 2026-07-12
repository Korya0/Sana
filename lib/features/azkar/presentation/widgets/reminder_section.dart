import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

class _ReminderSkeleton extends StatelessWidget {
  const _ReminderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.v8),
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('10:30'),
                          SizedBox(height: AppSpacing.v4),
                          Text(AppStrings.repeatDaily),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderErrorView extends StatelessWidget {
  const _ReminderErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.v16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
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
    final isGranted = await cubit.requestPermissions();
    if (!isGranted) {
      if (context.mounted) {
        await _showPermissionDeniedDialog(context);
      }
      return;
    }

    if (!context.mounted) return;
    final result = await showDialog<ReminderEntity>(
      context: context,
      builder: (dialogContext) => ReminderDialog(
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

  Future<void> _showPermissionDeniedDialog(
    BuildContext context, {
    String title = AppStrings.reminderPermissionDeniedTitle,
    String message = AppStrings.reminderPermissionDeniedMessage,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (context.mounted) {
                unawaited(context.read<ReminderCubit>().openSettings());
              }
            },
            child: const Text(AppStrings.openAppSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.reminderSectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _showReminderDialog(context),
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.reminderAdd),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.v8),
        BlocBuilder<ReminderCubit, ReminderState>(
          builder: (context, state) {
            if (state is ReminderLoading) {
              return const _ReminderSkeleton();
            }

            if (state is ReminderError) {
              return _ReminderErrorView(message: state.message);
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
                separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.v8),
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return ReminderTile(
                    reminder: reminder,
                    onToggle: (isEnabled) async {
                      if (isEnabled) {
                        final isGranted = await context
                            .read<ReminderCubit>()
                            .requestPermissions();
                        if (!isGranted) {
                          if (context.mounted) {
                            await _showPermissionDeniedDialog(context);
                          }
                          return;
                        }
                      }
                      if (!context.mounted) return;
                      unawaited(context
                          .read<ReminderCubit>()
                          .toggleReminder(
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

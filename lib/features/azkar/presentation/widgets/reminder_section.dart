import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/notification/i_notification_service.dart';
import 'package:sana/core/services/permissions/app_permissions_manager.dart';
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
            padding: const EdgeInsets.only(bottom: 8),
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
                          SizedBox(height: 4),
                          Text('يومياً'),
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
          const SizedBox(height: 16),
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
    // Check permission before showing dialog
    final notificationService = sl<INotificationService>();
    final canSchedule = await notificationService.canScheduleExactAlarms();
    if (!canSchedule) {
      if (context.mounted) {
        await _showPermissionDeniedDialog(context);
      }
      return;
    }

    if (!context.mounted) return;
    final cubit = context.read<ReminderCubit>();
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

  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    final permissionsManager = sl<IAppPermissionsManager>();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.reminderPermissionDeniedTitle),
        content: const Text(AppStrings.reminderPermissionDeniedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              unawaited(permissionsManager.openSettings());
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
            const Text(
              AppStrings.reminderSectionTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
        const SizedBox(height: 8),
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

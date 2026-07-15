import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/features/azkar/domain/entities/notification_template.dart';
import 'package:sana/features/azkar/domain/entities/repeat_type.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/domain/entities/reminder_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/reminder/reminder_state.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_dialog.dart';
import 'package:sana/features/azkar/presentation/widgets/reminder/reminder_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  static const _dummyReminder = ReminderEntity(
    id: 'dummy',
    azkarId: 'dummy',
    time: '10:30',
    repeatType: RepeatType.daily,
    days: [],
    isEnabled: true,
    timezone: 'UTC',
    template: NotificationTemplate.general,
  );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: List.generate(
          2,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.v8),
            child: ReminderTile(
              reminder: _dummyReminder,
              onToggle: (_) {},
              onDelete: () {},
              onTap: () {},
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
    return AppSectionCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.v24,
        horizontal: AppSpacing.v16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSpacing.v48,
            color: context.color.error,
          ),
          const AppGap.h(AppSpacing.v16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14W500(context).copyWith(
              color: context.color.error,
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

    // Show rationale dialog before requesting notification permission
    final userConsented = await showPermissionRationaleDialog(
      context: context,
      title: AppStrings.notificationPermissionTitle,
      message: AppStrings.notificationPermissionMessage,
    );
    if (!userConsented) return;

    if (!context.mounted) return;
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
      // Show success toast
      if (context.mounted) {
        AppToast.show(
          context,
          existingReminder != null
              ? AppStrings.reminderUpdatedSuccess
              : AppStrings.reminderCreatedSuccess,
        );
      }
    }
  }

  Future<void> _showPermissionDeniedDialog(
    BuildContext context, {
    String title = AppStrings.reminderPermissionDeniedTitle,
    String message = AppStrings.reminderPermissionDeniedMessage,
  }) async {
    await showCustomDialog<void>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.font20W700(context),
          ),
          const AppGap.h(AppSpacing.v16),
          Text(
            message,
            style: AppTextStyles.font14W500(
              context,
            ).copyWith(color: context.color.textSecondary),
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
                  text: AppStrings.openAppSettings,
                  onPressed: () {
                    AppNavigator.pop(context);
                    if (context.mounted) {
                      unawaited(context.read<ReminderCubit>().openSettings());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // T071: Hide UI entirely for unsupported category IDs
    if (!allowedReminderCategoryIds.contains(azkarId)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.reminderSectionTitle,
              style: AppTextStyles.font16W700(context),
            ),
            // T072: Hide Add button if a reminder already exists
            BlocSelector<ReminderCubit, ReminderState, bool>(
              selector: (state) =>
                  state is ReminderLoaded && state.reminders.isNotEmpty,
              builder: (context, hasReminders) {
                if (hasReminders) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () => _showReminderDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: AppSpacing.v20,
                        color: context.color.primary,
                      ),
                      const AppGap.w(AppSpacing.v4),
                      Text(
                        AppStrings.reminderAdd,
                        style: AppTextStyles.font14W700(
                          context,
                        ).copyWith(color: context.color.primary),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const AppGap.h(AppSpacing.v8),
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
                return const SizedBox.shrink();
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reminders.length,
                separatorBuilder: (context, index) =>
                    const AppGap.h(AppSpacing.v8),
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return ReminderTile(
                    reminder: reminder,
                    onToggle: (isEnabled) async {
                      if (isEnabled) {
                        // Show rationale dialog before requesting permission
                        if (!context.mounted) return;
                        final userConsented =
                            await showPermissionRationaleDialog(
                          context: context,
                          title: AppStrings.notificationPermissionTitle,
                          message: AppStrings.notificationPermissionMessage,
                        );
                        if (!userConsented) return;

                        if (!context.mounted) return;
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
                      unawaited(
                        context.read<ReminderCubit>().toggleReminder(
                          reminder.id,
                          azkarId,
                          isEnabled: isEnabled,
                        ),
                      );
                    },
                    onDelete: () {
                      unawaited(
                        context.read<ReminderCubit>().deleteReminder(
                          reminder.id,
                          azkarId,
                        ),
                      );
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

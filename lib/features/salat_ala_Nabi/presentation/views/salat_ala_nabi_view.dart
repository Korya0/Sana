import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/buttons/lightbulb_button.dart';
import 'package:sana/core/common/overlays/dialog/custom_confirmation_dialog.dart';
import 'package:sana/core/common/overlays/dialog/custom_info_dialog.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_cubit.dart';
import 'package:sana/features/salat_ala_nabi/presentation/cubit/reminder_state.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/salat_ala_nabi_skeleton.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/salat_ala_nabi_view_content.dart';

Future<void> showSalawatHelpDialog(BuildContext context) async {
  await showCustomInfoDialog(
    context: context,
    title: AppStrings.importantNotes,
    warningText: AppStrings.reminderDelayWarning,
    instructionsTitle: AppStrings.ensureServiceContinuity,
    instructions: [
      AppStrings.openAppDaily,
      AppStrings.reactivateServiceOccasionally,
      AppStrings.checkAppSettings,
    ],
  );
}

class SalatAlaNabiView extends StatelessWidget {
  const SalatAlaNabiView({super.key});

  Future<bool> _handlePopInvoked(
    BuildContext context,
    ReminderCubit cubit,
  ) async {
    if (!cubit.hasUnsavedChanges) {
      if (context.mounted) context.pop();
      return true;
    }

    await CustomConfirmationDialog.show(
      context,
      title: AppStrings.saveChangesQuestion,
      message: AppStrings.unsavedChangesMessage,
      confirmText: AppStrings.saveChanges,
      cancelText: AppStrings.discard,
      onConfirm: () async {
        final success = await cubit.saveChanges();
        if (context.mounted) {
          if (success) {
            AppToast.show(context, AppStrings.changesSavedSuccess);
          }
          context.pop();
        }
      },
      onCancel: () {
        cubit.discardChanges();
        context.pop();
      },
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReminderCubit>(),
      child: BlocBuilder<ReminderCubit, ReminderState>(
        builder: (context, state) {
          if (state is ReminderInitial || state is ReminderLoading) {
            return const SalatAlaNabiSkeleton();
          }

          if (state is ReminderError) {
            return Scaffold(
              body: AppErrorView(
                message: state.message,
                onRetry: () => context.read<ReminderCubit>().loadSettings(),
              ),
            );
          }

          if (state is! ReminderLoaded) return const SizedBox.shrink();

          final cubit = context.read<ReminderCubit>();

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              await _handlePopInvoked(context, cubit);
            },
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  CommonSliverAppBar(
                    onBackPressed: () =>
                        unawaited(_handlePopInvoked(context, cubit)),
                    title: AppStrings.salawatReminderTitle,
                    actions: [
                      LightbulbButton(
                        onPressed: () async {
                          unawaited(showSalawatHelpDialog(context));
                        },
                      ),
                    ],
                  ),
                  SalatAlaNabiViewContent(
                    settings: state.settings,
                    hasUnsavedChanges: cubit.hasUnsavedChanges,
                    onSave: () async {
                      final success = await cubit.saveChanges();
                      if (!context.mounted) return;
                      if (success) {
                        AppToast.show(
                          context,
                          AppStrings.changesSavedSuccess,
                        );
                      } else {
                        AppToast.show(
                          context,
                          AppStrings.ourFault,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/common/overlays/dialog/custom_confirmation_dialog.dart';
import 'package:sana/core/common/overlays/dialog/custom_info_dialog.dart';
import 'package:sana/core/common/overlays/toast/app_toast.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_state.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/views/skeletonizer_salat_ala_nabi_view.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/interval_counter_widget.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/notification_and_enable_salat_alarm_toggle_widget.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/working_hours_widget.dart';
import 'package:solar_icons/solar_icons.dart';

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

class SalatAlaNabiView extends StatefulWidget {
  const SalatAlaNabiView({super.key});

  @override
  State<SalatAlaNabiView> createState() => _SalatAlaNabiViewState();
}

class _SalatAlaNabiViewState extends State<SalatAlaNabiView> {
  Future<bool> _handlePopInvoked(ReminderCubit cubit) async {
    if (!cubit.hasUnsavedChanges) {
      if (mounted) context.pop();
      return true;
    }

    await CustomConfirmationDialog.show(
      context,
      title: AppStrings.saveChangesQuestion,
      message: AppStrings.unsavedChangesMessage,
      confirmText: AppStrings.saveChanges,
      cancelText: AppStrings.discard,
      onConfirm: () async {
        await cubit.saveChanges();
        if (mounted) context.pop();
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
            return const SkeletonizerSalatAlaNabiView();
          }

          if (state is ReminderError) {
            return Scaffold(body: Center(child: Text(state.message)));
          }

          final cubit = context.read<ReminderCubit>();

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              await _handlePopInvoked(cubit);
            },
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  CommonSliverAppBar(
                    onBackPressed: () => unawaited(_handlePopInvoked(cubit)),
                    title: AppStrings.salawatReminderTitle,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          unawaited(showSalawatHelpDialog(context));
                        },
                        child: const Icon(
                          SolarIconsBold.questionCircle,
                          color: AppColors.iconWhite,
                        ),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.v18,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: AppSpacing.v16),

                        const NotificationAndEnableSalatAlarmToggleWidget(),
                        const SizedBox(
                          height: AppSpacing.v18 * 2,
                        ),

                        // Interval Counter
                        const IntervalCounterWidget(),

                        const SizedBox(
                          height: AppSpacing.v18 * 2,
                        ),

                        // Working Hours Options
                        const WorkingHoursWidget(),

                        const SizedBox(
                          height: AppSpacing.v18 * 2,
                        ),

                        // Save Button
                        if (cubit.hasUnsavedChanges)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.v32,
                            ),
                            child: AppPrimaryButton(
                              text: AppStrings.saveChanges,
                              onPressed: () async {
                                await cubit.saveChanges();
                                if (!context.mounted) return;
                                AppToast.show(
                                  context,
                                  AppStrings.changesSavedSuccess,
                                );
                              },
                            ),
                          ),
                      ]),
                    ),
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

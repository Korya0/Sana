import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/common/widgets/custom_confirmation_dialog.dart';
import 'package:sana/core/constants/app_design.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/salat_ala_Nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/controller/reminder_cubit.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/views/skeletonizer_salat_ala_nabi_view.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/interval_counter_widget.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/notification_and_enable_salat_alarm_toggle_widget.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/show_salawat_help_dialog.dart';
import 'package:sana/features/salat_ala_Nabi/presentation/widgets/working_hours_widget.dart';

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
      child: BlocBuilder<ReminderCubit, ReminderSettings?>(
        builder: (context, settings) {
          if (settings == null) {
            return const SkeletonizerSalatAlaNabiView();
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
                          Icons.help_outline_rounded,
                          color: AppColors.iconWhite,
                        ),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDesign.horizontalP18,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 16),

                        const NotificationAndEnableSalatAlarmToggleWidget(),
                        const SizedBox(
                          height: AppDesign.betweenSections18 * 2,
                        ),

                        // Interval Counter
                        const IntervalCounterWidget(),

                        const SizedBox(
                          height: AppDesign.betweenSections18 * 2,
                        ),

                        // Working Hours Options
                        const WorkingHoursWidget(),

                        const SizedBox(
                          height: AppDesign.betweenSections18 * 2,
                        ),

                        // Save Button
                        if (cubit.hasUnsavedChanges)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: AppPrimaryButton(
                              text: AppStrings.saveChanges,
                              onPressed: () async {
                                await cubit.saveChanges();
                                if (!context.mounted) return;

                                setState(() {});
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

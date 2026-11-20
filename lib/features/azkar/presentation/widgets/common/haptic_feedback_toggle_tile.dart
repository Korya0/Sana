import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';

class HapticFeedbackToggleTile extends StatelessWidget {
  const HapticFeedbackToggleTile({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<AzkarTasbeehSettingsCubit, AzkarTasbeehSettingsState>(
    listenWhen: (previous, current) =>
        previous is! AzkarTasbeehSettingsError &&
        current is AzkarTasbeehSettingsError,
    listener: (context, state) {
      if (state is AzkarTasbeehSettingsError) {
        AppToast.show(context, state.message, type: AppToastType.error);
      }
    },
    child: BlocBuilder<AzkarTasbeehSettingsCubit, AzkarTasbeehSettingsState>(
      builder: (context, state) {
        final enabled = state.settingsOrDefault.hapticFeedbackEnabled;

        return SizedBox(
          height: AppSize.h56,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
            child: AppPressable(
              semanticLabel: AppStrings.hapticFeedback,
              excludeChildSemantics: true,
              onPressed: () => unawaited(
                context
                    .read<AzkarTasbeehSettingsCubit>()
                    .setHapticFeedbackEnabled(!enabled),
              ),
              child: Row(
                children: [
                  // Icon
                  Icon(
                    AppIcons.vibration,
                    size: AppSize.icon24,
                    color: context.color.iconNeutral,
                  ),
                  AppGap.w(AppSize.p12),

                  // Label
                  Expanded(
                    child: Text(
                      AppStrings.hapticFeedback,
                      maxLines: AppConstants.maxOneLine,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14W700Primary(context),
                    ),
                  ),
                  AppGap.w(AppSize.p8),

                  // Toggle — the whole row owns the tap
                  AbsorbPointer(
                    child: Switch(
                      value: enabled,
                      activeThumbColor: context.color.primary,
                      onChanged: (value) => unawaited(
                        context
                            .read<AzkarTasbeehSettingsCubit>()
                            .setHapticFeedbackEnabled(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

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
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';

class HapticFeedbackToggleTile extends StatelessWidget {
  // Creates tile
  const HapticFeedbackToggleTile({super.key});

  // Builds tile
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

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.p12,
            vertical: AppSize.p12,
          ),
          child: Row(
            children: [
              // Icon
              Icon(
                AppIcons.vibration,
                size: AppSize.icon24,
                color: context.color.iconPrimary,
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

              // Toggle
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: enabled,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
        );
      },
    ),
  );
}

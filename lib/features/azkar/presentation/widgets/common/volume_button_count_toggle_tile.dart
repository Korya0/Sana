import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';

class VolumeButtonCountToggleTile extends StatelessWidget {
  const VolumeButtonCountToggleTile({super.key});

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
        final supported = VolumeButtonsPlatform.isSupported;
        final enabled =
            supported && state.settingsOrDefault.volumeButtonCountEnabled;

        return AppPressable(
          semanticLabel: AppStrings.volumeButtonCount,
          excludeChildSemantics: true,
          onPressed: supported
              ? () => unawaited(
                  context
                      .read<AzkarTasbeehSettingsCubit>()
                      .setVolumeButtonCountEnabled(!enabled),
                )
              : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: AppSize.h56),
            child: Opacity(
              opacity: supported
                  ? AppConstants.opacityFull
                  : AppConstants.opacityDisabled,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
                child: Row(
                  children: [
                    // Icon
                    Icon(
                      AppIcons.volume,
                      size: AppSize.icon24,
                      color: context.color.iconNeutral,
                    ),
                    AppGap.w(AppSize.p12),

                    // Label and platform hint
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.volumeButtonCount,
                            maxLines: AppConstants.maxOneLine,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.font14W700Primary(context),
                          ),
                          if (!supported) ...[
                            AppGap.h(AppSize.p4),
                            Text(
                              AppStrings.volumeButtonCountUnsupported,
                              maxLines: AppConstants.maxOneLine,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.font12W500Secondary(context),
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppGap.w(AppSize.p8),

                    // Toggle — the whole row owns the tap
                    AbsorbPointer(
                      child: Switch(
                        value: enabled,
                        activeThumbColor: context.color.primary,
                        onChanged: supported
                            ? (value) => unawaited(
                                context
                                    .read<AzkarTasbeehSettingsCubit>()
                                    .setVolumeButtonCountEnabled(value),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

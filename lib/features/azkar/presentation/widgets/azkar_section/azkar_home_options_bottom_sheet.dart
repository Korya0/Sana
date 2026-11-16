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
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_tile.dart';

enum AzkarHomeOption { fontSize, createCustomAzkar, manageCustomAzkar }

class AzkarHomeOptionsBottomSheet extends StatelessWidget {
  // Creates sheet
  const AzkarHomeOptionsBottomSheet({
    required this.readingSettingsCubit,
    super.key,
  });

  final ReadingSettingsCubit readingSettingsCubit;

  // Builds sheet
  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: readingSettingsCubit,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p20,
        vertical: AppSize.p16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Reading section
          AzkarOptionSection(
            title: AppStrings.readingSettingsTitle,
            children: [
              AzkarOptionTile(
                icon: AppIcons.fontSize,
                label: AppStrings.fontSize,
                onPressed: () => context.popOnce(AzkarHomeOption.fontSize),
              ),
              // Haptics
              BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
                builder: (context, state) {
                  final enabled = switch (state) {
                    ReadingSettingsLoaded(:final settings) =>
                      settings.hapticFeedbackEnabled,
                    ReadingSettingsError(:final settings?) =>
                      settings.hapticFeedbackEnabled,
                    _ => ReadingSettingsEntity.defaultHapticFeedbackEnabled,
                  };

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
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeThumbColor: context.color.primary,
                            onChanged: (value) {
                              readingSettingsCubit
                                  .changeHapticFeedbackEnabled(value);
                              unawaited(
                                readingSettingsCubit.saveSettings(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          AppGap.h(AppSize.p16),

          // Custom azkar section
          AzkarOptionSection(
            title: AppStrings.customAzkar,
            children: [
              AzkarOptionTile(
                icon: AppIcons.add,
                label: AppStrings.createCustomAzkar,
                onPressed: () =>
                    context.popOnce(AzkarHomeOption.createCustomAzkar),
              ),
              AzkarOptionTile(
                icon: AppIcons.adhkar,
                label: AppStrings.manageCustomAzkar,
                onPressed: () =>
                    context.popOnce(AzkarHomeOption.manageCustomAzkar),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

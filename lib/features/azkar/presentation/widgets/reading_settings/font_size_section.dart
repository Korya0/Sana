import 'package:sana/core/common/common.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/data/constants/azkar_constants.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

class FontSizeSection extends StatefulWidget {
  const FontSizeSection({super.key});

  @override
  State<FontSizeSection> createState() => _FontSizeSectionState();
}

class _FontSizeSectionState extends State<FontSizeSection> {
  double? _localFontSize;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingSettingsCubit>();

    return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
      builder: (context, state) {
        final cubitSize = state is ReadingSettingsLoaded
            ? state.settings.fontSize
            : AzkarConstants.defaultFontSize;

        // Use local state if user is dragging, otherwise use cubit state
        final currentSize = _localFontSize ?? cubitSize;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.fontSizeTitle,
                    style: AppTextStyles.font16W700(
                      context,
                    ).copyWith(color: context.color.textPrimary),
                  ),
                  Text(
                    '${currentSize.toInt()}',
                    style: AppTextStyles.font14W700(
                      context,
                    ).copyWith(color: context.color.primary),
                  ),
                ],
              ),
            ),
            const AppGap.h(AppSpacing.v8),
            Slider(
              value: currentSize,
              min: AzkarConstants.minFontSize,
              max: AzkarConstants.maxFontSize,
              divisions: 8,
              activeColor: context.color.primary,
              inactiveColor: context.color.primary.withValues(alpha: 0.2),
              onChanged: (newValue) {
                // Only update local UI (preview and slider) to avoid heavy list rebuilds
                setState(() => _localFontSize = newValue);
              },
              onChangeEnd: (finalValue) {
                // Commit to cubit and save when dragging finishes
                setState(() => _localFontSize = null);
                cubit.changeFontSize(finalValue);
                unawaited(cubit.saveSettings());
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.fontSmall,
                    style: AppTextStyles.font12W500(context).copyWith(
                      color: context.color.textSecondary,
                    ),
                  ),
                  Text(
                    AppStrings.fontLarge,
                    style: AppTextStyles.font12W500(context).copyWith(
                      color: context.color.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const AppGap.h(AppSpacing.v24),
            Container(
              padding: const EdgeInsets.all(AppSpacing.v16),
              decoration: BoxDecoration(
                color: context.color.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(
                  color: context.color.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    AppStrings.fontSizePreviewText,
                    style: AppTextStyles.fontCustomW700(context, currentSize).copyWith(
                      color: context.color.textPrimary,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

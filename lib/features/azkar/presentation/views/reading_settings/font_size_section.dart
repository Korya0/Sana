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

class FontSizeSection extends StatelessWidget {
  const FontSizeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingSettingsCubit>();

    return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
      builder: (context, state) {
        final currentSize = state is ReadingSettingsLoaded
            ? state.settings.fontSize
            : AzkarConstants.defaultFontSize;

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
            const SizedBox(height: AppSpacing.v8),
            Semantics(
              label: AppStrings.fontSizeTitle,
              value: '${currentSize.toInt()}',
              slider: true,
              onIncrease: () {
                if (currentSize < AzkarConstants.maxFontSize) {
                  cubit.changeFontSize(currentSize + 2);
                  unawaited(cubit.saveSettings());
                }
              },
              onDecrease: () {
                if (currentSize > AzkarConstants.minFontSize) {
                  cubit.changeFontSize(currentSize - 2);
                  unawaited(cubit.saveSettings());
                }
              },
              child: Slider(
                value: currentSize,
                min: AzkarConstants.minFontSize,
                max: AzkarConstants.maxFontSize,
                divisions: 8,
                activeColor: context.color.primary,
                inactiveColor: context.color.primary.withValues(alpha: 0.2),
                onChanged: cubit.changeFontSize,
                onChangeEnd: (_) => cubit.saveSettings(),
              ),
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
            const SizedBox(height: AppSpacing.v24),
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
                    style: AppTextStyles.font20W700(context).copyWith(
                      fontSize: currentSize,
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

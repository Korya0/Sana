import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

class FontSizeSection extends StatefulWidget {
  const FontSizeSection({super.key});

  @override
  State<FontSizeSection> createState() => _FontSizeSectionState();
}

class _FontSizeSectionState extends State<FontSizeSection> {
  double? _pendingFontSize;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingSettingsCubit>();

    return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
      builder: (context, state) {
        final savedSize = switch (state) {
          ReadingSettingsLoaded(:final settings) => settings.fontSize,
          ReadingSettingsError(:final settings?) => settings.fontSize,
          _ => ReadingSettingsEntity.defaultFontSize,
        };
        final currentSize = _pendingFontSize ?? savedSize;
        const minSize = ReadingSettingsEntity.minFontSize;
        const maxSize = ReadingSettingsEntity.maxFontSize;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label + value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    AppStrings.fontSizeTitle,
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.font16W700Primary(context),
                  ),
                ),
                Flexible(
                  child: Text(
                    '${currentSize.toInt()}',
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.font14W700Brand(context),
                  ),
                ),
              ],
            ),
            AppGap.h(AppSize.p8),

            // Slider
            Slider(
              value: currentSize.clamp(minSize, maxSize),
              min: minSize,
              max: maxSize,
              divisions: AppConstants.fontSizeSliderDivisions,
              activeColor: context.color.primary,
              inactiveColor: context.color.surfaceDisabled,
              onChanged: (value) => setState(() => _pendingFontSize = value),
              onChangeEnd: (value) {
                setState(() => _pendingFontSize = null);
                cubit.changeFontSize(value);
                unawaited(cubit.saveSettings());
              },
            ),

            // Range labels
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.fontSmall,
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.font12W500Secondary(context),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppStrings.fontLarge,
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.font12W500Secondary(context),
                  ),
                ),
              ],
            ),
            AppGap.h(AppSize.p24),

            // Preview
            AppSectionCard(
              child: Text(
                AppStrings.fontSizePreviewText,
                textAlign: TextAlign.center,
                style: AppTextStyles.fontZikrW700Primary(context, currentSize),
              ),
            ),
          ],
        );
      },
    );
  }
}

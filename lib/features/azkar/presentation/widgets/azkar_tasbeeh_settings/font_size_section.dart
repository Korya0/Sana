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
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/features/azkar/domain/entities/azkar_tasbeeh_settings_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_settings/font_size_thumb_shape.dart';

class FontSizeSection extends StatefulWidget {
  // Creates section
  const FontSizeSection({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<FontSizeSection> createState() => _FontSizeSectionState();
}

class _FontSizeSectionState extends State<FontSizeSection> {
  double? _pendingFontSize;

  // Initializes state
  @override
  void initState() {
    super.initState();
    // Show load errors when the sheet opens after a failed fetch.
    final state = context.read<AzkarTasbeehSettingsCubit>().state;
    if (state is AzkarTasbeehSettingsError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppToast.show(context, state.message, type: AppToastType.error);
        }
      });
    }
  }

  // Builds section
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AzkarTasbeehSettingsCubit>();

    return BlocBuilder<AzkarTasbeehSettingsCubit, AzkarTasbeehSettingsState>(
      builder: (context, state) {
        final savedSize = state.settingsOrDefault.fontSize;
        final currentSize = _pendingFontSize ?? savedSize;
        const minSize = AzkarTasbeehSettingsEntity.minFontSize;
        const maxSize = AzkarTasbeehSettingsEntity.maxFontSize;

        return OptionSection(
          title: AppStrings.fontSize,
          leading: widget.showBackButton
              ? AppIconButton(
                  icon: AppIcons.back,
                  tooltip: AppStrings.back,
                  onPressed: () => context.popOnce(true),
                )
              : null,
          children: [
            // Preview label
            Padding(
              padding: EdgeInsetsDirectional.only(start: AppSize.p4),
              child: Text(
                AppStrings.fontSizePreview,
                maxLines: AppConstants.maxOneLine,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.font12W500Secondary(context),
              ),
            ),
            AppGap.h(AppSize.p8),
            // Preview text
            SizedBox(
              // Fixed height so only the preview text scales.
              height: AppSize.h64,
              child: Center(
                child: Text(
                  AppStrings.fontSizePreviewText,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.fontZikrW700Primary(
                    context,
                    currentSize,
                  ),
                ),
              ),
            ),
            AppGap.h(AppSize.p16),

            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: FontSizeThumbShape(
                  min: minSize,
                  max: maxSize,
                  radius: AppSize.r18,
                  backgroundColor: context.color.surfaceBrand,
                  textStyle: AppTextStyles.font14W700OnPrimary(context),
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: AppSize.r26,
                ),
              ),
              child: Slider(
                value: currentSize.clamp(minSize, maxSize),
                min: minSize,
                max: maxSize,
                divisions: AppConstants.fontSizeSliderDivisions,
                activeColor: context.color.primary,
                inactiveColor: context.color.surfaceDisabled,
                onChanged: (value) => setState(() => _pendingFontSize = value),
                onChangeEnd: (value) {
                  setState(() => _pendingFontSize = null);
                  cubit.previewFontSize(value);
                  unawaited(cubit.saveSettings());
                },
              ),
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
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';

enum AzkarCategoryAction { fontSize, edit, restore, delete }

class AzkarCategoryActionsBottomSheet extends StatelessWidget {
  // Creates sheet
  const AzkarCategoryActionsBottomSheet({
    required this.isCustom,
    super.key,
    this.canRestore = false,
    this.showAzkarTasbeehSettings = false,
    this.azkarTasbeehSettingsCubit,
  });

  final bool isCustom;
  final bool canRestore;
  final bool showAzkarTasbeehSettings;
  final AzkarTasbeehSettingsCubit? azkarTasbeehSettingsCubit;

  // Builds sheet
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.p20,
      vertical: AppSize.p16,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Reading settings
        if (showAzkarTasbeehSettings && azkarTasbeehSettingsCubit != null) ...[
          BlocProvider.value(
            value: azkarTasbeehSettingsCubit!,
            child: OptionSection(
              title: AppStrings.azkarTasbeehSettingsTitle,
              children: [
                OptionTile(
                  icon: AppIcons.fontSize,
                  label: AppStrings.fontSize,
                  onPressed: () =>
                      context.popOnce(AzkarCategoryAction.fontSize),
                ),
                // Haptics
                const HapticFeedbackToggleTile(),
              ],
            ),
          ),
          AppGap.h(AppSize.p16),
        ],

        // Actions section
        OptionSection(
          title: AppStrings.azkarOptions,
          children: [
            // Edit action
            OptionTile(
              icon: AppIcons.edit,
              label: AppStrings.editAzkar,
              onPressed: () => context.popOnce(AzkarCategoryAction.edit),
            ),
            AppGap.h(AppSize.p8),

            // Secondary actions
            Row(
              children: [
                // Restore action
                if (!isCustom)
                  Expanded(
                    child: AppTextButton(
                      label: AppStrings.restoreOriginal,
                      expand: true,
                      onPressed: canRestore
                          ? () => context.popOnce(AzkarCategoryAction.restore)
                          : null,
                    ),
                  ),
                // Gap
                if (!isCustom && isCustom) AppGap.w(AppSize.p8),

                // Delete action
                if (isCustom)
                  Expanded(
                    child: AppTextButton(
                      label: AppStrings.delete,
                      expand: true,
                      textStyle: AppTextStyles.font14W700Error(context),
                      onPressed: () =>
                          context.popOnce(AzkarCategoryAction.delete),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

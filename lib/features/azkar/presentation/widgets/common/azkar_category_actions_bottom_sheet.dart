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
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_settings_section.dart';

enum AzkarCategoryAction { fontSize, edit, restore, delete }

class AzkarCategoryActionsBottomSheet extends StatelessWidget {
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

  Widget _withSettings(Widget child) {
    final cubit = azkarTasbeehSettingsCubit;
    if (!showAzkarTasbeehSettings || cubit == null) return child;
    return BlocProvider.value(value: cubit, child: child);
  }

  @override
  Widget build(BuildContext context) => _withSettings(
    AzkarOptionsSheetScaffold(
      children: [
        if (showAzkarTasbeehSettings && azkarTasbeehSettingsCubit != null) ...[
          ReadingSettingsSection(
            onFontSizeTap: () => context.popOnce(AzkarCategoryAction.fontSize),
          ),
          AppGap.h(AppSize.p16),
        ],
        OptionSection(
          title: AppStrings.azkarOptions,
          children: [
            OptionTile(
              icon: AppIcons.edit,
              label: AppStrings.editAzkar,
              onPressed: () => context.popOnce(AzkarCategoryAction.edit),
            ),
            AppGap.h(AppSize.p8),
            Row(
              children: [
                if (!isCustom)
                  Expanded(
                    child: AppTextButton(
                      icon: AppIcons.refresh,
                      label: AppStrings.restoreOriginal,
                      expand: true,
                      onPressed: canRestore
                          ? () => context.popOnce(AzkarCategoryAction.restore)
                          : null,
                    ),
                  ),
                if (isCustom)
                  Expanded(
                    child: AppTextButton(
                      icon: AppIcons.delete,
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

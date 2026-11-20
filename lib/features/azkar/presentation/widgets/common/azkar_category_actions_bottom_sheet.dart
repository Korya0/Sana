import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_button_count_toggle_tile.dart';

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
  Widget build(BuildContext context) {
    final hasSettings =
        showAzkarTasbeehSettings && azkarTasbeehSettingsCubit != null;

    return _withSettings(
      AzkarOptionsSheetScaffold(
        title: AppStrings.azkarOptions,
        onDismiss: () => context.popOnce(),
        children: [
          if (hasSettings) ...[
            OptionTile(
              icon: AppIcons.fontSize,
              label: AppStrings.fontSize,
              onPressed: () => context.popOnce(AzkarCategoryAction.fontSize),
            ),
            const HapticFeedbackToggleTile(),
            const VolumeButtonCountToggleTile(),
          ],
          OptionTile(
            icon: AppIcons.edit,
            label: AppStrings.editZikr,
            onPressed: () => context.popOnce(AzkarCategoryAction.edit),
          ),
          if (!isCustom)
            OptionTile(
              icon: AppIcons.refresh,
              label: AppStrings.restoreOriginal,
              isDestructive: true,
              onPressed: canRestore
                  ? () => context.popOnce(AzkarCategoryAction.restore)
                  : null,
            ),
          if (isCustom)
            OptionTile(
              icon: AppIcons.close,
              label: AppStrings.deleteZikr,
              isDestructive: true,
              onPressed: () => context.popOnce(AzkarCategoryAction.delete),
            ),
        ],
      ),
    );
  }
}

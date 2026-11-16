import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/reading_settings_entity.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_option_tile.dart';

enum TasbeehManagerAction { fontSize, create, select, edit, delete }

typedef TasbeehManagerResult = ({TasbeehManagerAction action, String? itemId});

class TasbeehOptionsBottomSheet extends StatelessWidget {
  // Creates sheet
  const TasbeehOptionsBottomSheet({
    required this.items,
    required this.selectedId,
    required this.readingSettingsCubit,
    super.key,
  });

  final List<TasbeehItemEntity> items;
  final String? selectedId;
  final ReadingSettingsCubit readingSettingsCubit;

  // Builds sheet
  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: readingSettingsCubit,
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        AppSize.p20,
        AppSize.p16,
        AppSize.p20,
        AppSize.p16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Reading
          AzkarOptionSection(
            title: AppStrings.readingSettingsTitle,
            children: [
              // Font size
              AzkarOptionTile(
                icon: AppIcons.fontSize,
                label: AppStrings.fontSize,
                onPressed: () => context.popOnce((
                  action: TasbeehManagerAction.fontSize,
                  itemId: null,
                )),
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
                              unawaited(readingSettingsCubit.saveSettings());
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

          // Items
          Flexible(
            child: AzkarOptionSection(
              title: AppStrings.allTasbeeh,
              children: [
                if (items.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.p12),
                    child: Text(
                      AppStrings.tasbeehEmpty,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14W500Secondary(context),
                    ),
                  )
                else
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.4,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) => _TasbeehItemTile(
                          item: items[index],
                          isSelected: items[index].id == selectedId,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppGap.h(AppSize.p8),

          // Create
          AppTextButton(
            label: AppStrings.addTasbeeh,
            expand: true,
            onPressed: () => context.popOnce((
              action: TasbeehManagerAction.create,
              itemId: null,
            )),
          ),
        ],
      ),
    ),
  );
}

class _TasbeehItemTile extends StatelessWidget {
  // Creates tile
  const _TasbeehItemTile({
    required this.item,
    required this.isSelected,
  });

  final TasbeehItemEntity item;
  final bool isSelected;

  // Builds tile
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: AppSize.p4),
    child: Row(
      children: [
        // Select
        Expanded(
          child: AppPressable(
            onPressed: () => context.popOnce((
              action: TasbeehManagerAction.select,
              itemId: item.id,
            )),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.p8),
              child: Text(
                item.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: isSelected
                    ? AppTextStyles.font14W700Brand(context)
                    : AppTextStyles.font14W700Primary(context),
              ),
            ),
          ),
        ),

        // Edit
        AppIconButton(
          icon: AppIcons.edit,
          tooltip: AppStrings.editTasbeeh,
          onPressed: () => context.popOnce((
            action: TasbeehManagerAction.edit,
            itemId: item.id,
          )),
        ),

        // Delete
        AppIconButton(
          icon: AppIcons.delete,
          tooltip: AppStrings.deleteTasbeeh,
          color: AppColorsCommon.errorColor,
          onPressed: () => context.popOnce((
            action: TasbeehManagerAction.delete,
            itemId: item.id,
          )),
        ),
      ],
    ),
  );
}

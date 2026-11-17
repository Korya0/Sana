import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/common/haptic_feedback_toggle_tile.dart';

enum TasbeehOption { fontSize, create, select, edit, delete }

typedef TasbeehOptionResult = ({TasbeehOption action, String? selectedItemId});

class TasbeehOptionsBottomSheet extends StatelessWidget {
  // Creates sheet
  const TasbeehOptionsBottomSheet({
    required this.items,
    required this.selectedItemId,
    required this.azkarTasbeehSettingsCubit,
    super.key,
  });

  final List<TasbeehItemEntity> items;
  final String? selectedItemId;
  final AzkarTasbeehSettingsCubit azkarTasbeehSettingsCubit;

  // Builds sheet
  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: azkarTasbeehSettingsCubit,
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
          OptionSection(
            title: AppStrings.azkarTasbeehSettingsTitle,
            children: [
              // Font size
              OptionTile(
                icon: AppIcons.fontSize,
                label: AppStrings.fontSize,
                onPressed: () => context.popOnce((
                  action: TasbeehOption.fontSize,
                  selectedItemId: null,
                )),
              ),

              // Haptics
              const HapticFeedbackToggleTile(),
            ],
          ),
          AppGap.h(AppSize.p16),

          // Items
          Flexible(
            child: OptionSection(
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
                          isSelected: items[index].id == selectedItemId,
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
              action: TasbeehOption.create,
              selectedItemId: null,
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
              action: TasbeehOption.select,
              selectedItemId: item.id,
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
            action: TasbeehOption.edit,
            selectedItemId: item.id,
          )),
        ),

        // Delete
        AppIconButton(
          icon: AppIcons.delete,
          tooltip: AppStrings.deleteTasbeeh,
          color: context.color.errorText,
          onPressed: () => context.popOnce((
            action: TasbeehOption.delete,
            selectedItemId: item.id,
          )),
        ),
      ],
    ),
  );
}

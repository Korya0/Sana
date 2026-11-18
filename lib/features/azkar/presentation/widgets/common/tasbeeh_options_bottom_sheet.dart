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
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';
import 'package:sana/features/azkar/presentation/widgets/common/option_section.dart';
import 'package:sana/features/azkar/presentation/widgets/common/reading_settings_section.dart';

enum TasbeehOption { fontSize, create, select, edit, delete }

typedef TasbeehOptionResult = ({TasbeehOption action, String? selectedItemId});

class TasbeehOptionsBottomSheet extends StatelessWidget {
  const TasbeehOptionsBottomSheet({
    required this.items,
    required this.selectedItemId,
    required this.azkarTasbeehSettingsCubit,
    super.key,
    this.showReadingSettings = true,
  });

  final List<TasbeehItemEntity> items;
  final String? selectedItemId;
  final AzkarTasbeehSettingsCubit azkarTasbeehSettingsCubit;
  final bool showReadingSettings;

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: azkarTasbeehSettingsCubit,
    child: AzkarOptionsSheetScaffold(
      children: [
        if (showReadingSettings) ...[
          ReadingSettingsSection(
            onFontSizeTap: () => context.popOnce((
              action: TasbeehOption.fontSize,
              selectedItemId: null,
            )),
          ),
          AppGap.h(AppSize.p16),
        ],
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
                      maxHeight:
                          MediaQuery.sizeOf(context).height *
                          AppConstants.sheetMaxHeightRatio,
                    ),
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: [
                        AppSliverList(
                          itemCount: items.length,
                          itemBuilder: (context, index) => _TasbeehItemTile(
                            item: items[index],
                            isSelected: items[index].id == selectedItemId,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        AppGap.h(AppSize.p8),
        AppTextButton(
          icon: AppIcons.add,
          label: AppStrings.addTasbeeh,
          expand: true,
          onPressed: () => context.popOnce((
            action: TasbeehOption.create,
            selectedItemId: null,
          )),
        ),
      ],
    ),
  );
}

class _TasbeehItemTile extends StatelessWidget {
  const _TasbeehItemTile({required this.item, required this.isSelected});

  final TasbeehItemEntity item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.p4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: isSelected
                        ? AppTextStyles.font14W700Brand(context)
                        : AppTextStyles.font14W700Primary(context),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  icon: AppIcons.edit,
                  tooltip: AppStrings.editTasbeeh,
                  onPressed: () => context.popOnce((
                    action: TasbeehOption.edit,
                    selectedItemId: item.id,
                  )),
                ),
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
          ],
        ),
      ),
      const AppDivider(),
    ],
  );
}

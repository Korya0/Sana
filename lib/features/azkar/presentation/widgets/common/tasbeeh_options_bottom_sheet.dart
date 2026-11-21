import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_options_sheet_scaffold.dart';

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
      title: AppStrings.tasbeehListTitle,
      onDismiss: () => context.popOnce(),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++)
                _TasbeehItemTile(
                  item: items[i],
                  showDivider: i < items.length - 1,
                ),
            ],
          ),
      ],
    ),
  );
}

class _TasbeehItemTile extends StatelessWidget {
  const _TasbeehItemTile({
    required this.item,
    required this.showDivider,
  });

  final TasbeehItemEntity item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.p4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppPressable(
                onPressed: () => context.popOnce((
                  action: TasbeehOption.select,
                  selectedItemId: item.id,
                )),
                child: Container(
                  constraints: BoxConstraints(minHeight: AppSize.w48),
                  alignment: AlignmentDirectional.centerStart,
                  padding: EdgeInsets.symmetric(vertical: AppSize.p8),
                  child: Text(
                    item.text,
                    maxLines: AppConstants.maxOneLine,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.font14W700Primary(context),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
      if (showDivider) const AppDivider(),
    ],
  );
}

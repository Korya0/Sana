import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_text_button.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_item_card.dart';

class TasbeehLoadedBody extends StatelessWidget {
  const TasbeehLoadedBody({
    required this.selectedItem,
    required this.onAdd,
    required this.onOpenList,
    super.key,
  });

  final TasbeehItemEntity selectedItem;
  final VoidCallback onAdd;
  final VoidCallback onOpenList;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Align(
      alignment: AlignmentDirectional.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSize.contentMaxWidth),
        child: Padding(
          padding: AppSize.shp.copyWith(top: AppSize.p8, bottom: AppSize.p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextButton(
                    icon: AppIcons.add,
                    label: AppStrings.addTasbeeh,
                    onPressed: onAdd,
                  ),
                  AppTextButton(
                    icon: AppIcons.list,
                    label: AppStrings.tasbeehListTitle,
                    onPressed: onOpenList,
                  ),
                ],
              ),
              AppGap.h(AppSize.p8),
              const AppDivider(),
              AppGap.h(AppSize.p16),
              TasbeehItemCard(item: selectedItem),
            ],
          ),
        ),
      ),
    ),
  );
}

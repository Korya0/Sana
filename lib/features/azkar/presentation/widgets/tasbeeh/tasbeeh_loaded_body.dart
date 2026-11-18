import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_label_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_content.dart';

class TasbeehLoadedBody extends StatelessWidget {
  const TasbeehLoadedBody({
    required this.selectedItem,
    required this.canReset,
    required this.onOpenSavedItems,
    required this.onReset,
    super.key,
  });

  final TasbeehItemEntity selectedItem;
  final bool canReset;
  final VoidCallback onOpenSavedItems;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) => SliverFillRemaining(
    hasScrollBody: false,
    child: Padding(
      padding: EdgeInsetsDirectional.only(
        start: AppSize.p16,
        end: AppSize.p16,
        top: AppSize.p8,
        bottom: AppSize.p16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _TasbeehSelectionButton(
                  item: selectedItem,
                  onPressed: onOpenSavedItems,
                ),
              ),
              AppGap.w(AppSize.p8),
              AppIconLabelButton(
                key: const ValueKey('tasbeeh_reset_button'),
                icon: AppIcons.refresh,
                label: AppStrings.resetCounter,
                onPressed: canReset ? onReset : null,
              ),
            ],
          ),
          AppGap.h(AppSize.p16),
          Expanded(child: TasbeehCounterContent(item: selectedItem)),
        ],
      ),
    ),
  );
}

class _TasbeehSelectionButton extends StatelessWidget {
  const _TasbeehSelectionButton({
    required this.item,
    required this.onPressed,
  });

  final TasbeehItemEntity item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AppPressable(
    key: const ValueKey('tasbeeh_selection_button'),
    onPressed: onPressed,
    semanticLabel: AppStrings.tasbeehSelectorSemantics(item.text),
    excludeChildSemantics: true,
    child: Container(
      height: AppSize.h64,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p12,
        vertical: AppSize.p8,
      ),
      decoration: BoxDecoration(
        color: context.color.secondaryScaffoldBackgroundColor,
        border: Border.all(
          color: context.color.dividerColor,
          width: AppSize.borderWidth,
        ),
        borderRadius: BorderRadius.circular(AppSize.r16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.chooseTasbeeh,
                  maxLines: AppConstants.maxOneLine,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12W500Secondary(context),
                ),
                AppGap.h(AppSize.p4),
                Text(
                  item.text,
                  maxLines: AppConstants.maxOneLine,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font14W700Primary(context),
                ),
              ],
            ),
          ),
          AppGap.w(AppSize.p8),
          Icon(
            AppIcons.dropdown,
            size: AppSize.icon24,
            color: context.color.iconBrand,
          ),
        ],
      ),
    ),
  );
}

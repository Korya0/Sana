import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/buttons/app_icon_button.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/tasbeeh/tasbeeh_counter_content.dart';

class TasbeehLoadedBody extends StatelessWidget {
  const TasbeehLoadedBody({
    required this.selectedItem,
    required this.previousItem,
    required this.nextItem,
    required this.canReset,
    required this.onSelect,
    required this.onReset,
    super.key,
  });

  final TasbeehItemEntity selectedItem;
  final TasbeehItemEntity? previousItem;
  final TasbeehItemEntity? nextItem;
  final bool canReset;
  final ValueChanged<String> onSelect;
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
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(
                  child: _TasbeehNeighborButton(
                    text: previousItem?.text ?? AppStrings.previousTasbeeh,
                    icon: AppIcons.previousItem,
                    onPressed: previousItem == null
                        ? null
                        : () => onSelect(previousItem!.id),
                  ),
                ),
                AppIconButton(
                  icon: AppIcons.refresh,
                  tooltip: AppStrings.resetCounter,
                  color: canReset
                      ? context.color.iconBrand
                      : context.color.iconDisabled,
                  onPressed: canReset ? onReset : null,
                ),
                Expanded(
                  child: _TasbeehNeighborButton(
                    text: nextItem?.text ?? AppStrings.nextTasbeeh,
                    icon: AppIcons.nextItem,
                    isNext: true,
                    onPressed: nextItem == null
                        ? null
                        : () => onSelect(nextItem!.id),
                  ),
                ),
              ],
            ),
          ),
          AppGap.h(AppSize.p24),
          Expanded(child: TasbeehCounterContent(item: selectedItem)),
        ],
      ),
    ),
  );
}

class _TasbeehNeighborButton extends StatelessWidget {
  const _TasbeehNeighborButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isNext = false,
  });

  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isNext;

  @override
  Widget build(BuildContext context) => AppPressable(
    onPressed: onPressed,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p8),
      child: Row(
        mainAxisAlignment: isNext
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isNext) ...[
            Icon(
              icon,
              size: AppSize.icon24,
              color: onPressed == null
                  ? context.color.iconDisabled
                  : context.color.iconBrand,
            ),
            AppGap.w(AppSize.p4),
          ],
          Flexible(
            child: Text(
              text,
              maxLines: AppConstants.maxOneLine,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: onPressed == null
                  ? AppTextStyles.font12W500Secondary(context)
                  : AppTextStyles.font14W700Primary(context),
            ),
          ),
          if (isNext) ...[
            AppGap.w(AppSize.p4),
            Icon(
              icon,
              size: AppSize.icon24,
              color: onPressed == null
                  ? context.color.iconDisabled
                  : context.color.iconBrand,
            ),
          ],
        ],
      ),
    ),
  );
}

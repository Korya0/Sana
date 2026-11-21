import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';

class TasbeehRecentItem extends StatelessWidget {
  const TasbeehRecentItem({
    required this.item,
    required this.onContinue,
    super.key,
    this.onCount,
    this.onOpenAll,
  });

  final TasbeehItemEntity item;
  final VoidCallback onContinue;
  final VoidCallback? onCount;
  final VoidCallback? onOpenAll;

  @override
  Widget build(BuildContext context) => TasbeehBeadCounter(
    count: item.currentCount,
    subtitle: item.text,
    progress: item.progress,
    subtitleMaxLines: AppConstants.maxTwoLines,
    subtitleStyle: AppTextStyles.font16W700Primary(context),
    contentBottom: AppSize.p4,
    onPressed: onContinue,
    action: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.continueCounting,
          style: AppTextStyles.font11W700Primary(context).copyWith(
            fontSize: AppSize.f11 * 0.85,
            color: context.color.textBrand,
          ),
        ),
        AppGap.w(AppSize.p2),
        Transform.flip(
          flipX: true,
          child: Icon(
            AppIcons.play,
            size: AppSize.p8 + AppSize.p2,
            color: context.color.textBrand,
          ),
        ),
      ],
    ),
  );
}

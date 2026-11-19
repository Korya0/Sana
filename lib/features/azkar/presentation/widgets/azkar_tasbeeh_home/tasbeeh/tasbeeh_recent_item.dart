import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/tasbeeh_item_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_bead_counter.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_chip.dart';

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
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TasbeehBeadCounter(
        count: item.currentCount,
        subtitle: item.text,
        progress: item.progress,
        subtitleMaxLines: AppConstants.maxTwoLines,
        contentBottom: AppSize.p20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TasbeehChip(
            label: AppStrings.continueCounting,
            icon: AppIcons.arrowForward,
            onPressed: onContinue,
          ),
        ],
      ),
    ],
  );
}

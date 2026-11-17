import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TasbeehPresetGridSkeleton extends StatelessWidget {
  const TasbeehPresetGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Skeletonizer(
    child: IgnorePointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.startTasbeeh,
            style: AppTextStyles.font14W700Primary(context),
          ),
          AppGap.h(AppSize.p12),
          TasbeehPresetGrid(onSelect: (_) {}, onCustomTap: () {}),
        ],
      ),
    ),
  );
}

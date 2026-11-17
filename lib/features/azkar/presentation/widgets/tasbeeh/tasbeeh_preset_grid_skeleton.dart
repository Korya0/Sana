import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/features/azkar/presentation/widgets/common/tasbeeh_preset_grid.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TasbeehPresetGridSkeleton extends StatelessWidget {
  const TasbeehPresetGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Skeletonizer(
    child: IgnorePointer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSize.p16),
        child: TasbeehPresetGrid(onSelect: (_) {}, onCustomTap: () {}),
      ),
    ),
  );
}

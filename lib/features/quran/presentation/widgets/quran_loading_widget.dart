import 'package:flutter/material.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class QuranLoadingWidget extends StatelessWidget {
  const QuranLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.color.secondaryScaffoldBackgroundColor,
      child: Skeletonizer(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.v16.r(context)),
          child: Column(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.v12),
                child: Container(
                  width: double.infinity,
                  height: AppSpacing.h24.r(context),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

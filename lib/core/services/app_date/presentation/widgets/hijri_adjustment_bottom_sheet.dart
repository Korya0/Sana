import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/core/services/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';

class HijriAdjustmentBottomSheet extends StatelessWidget {
  const HijriAdjustmentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDateCubit, AppDateState>(
      builder: (context, state) {
        if (state is! AppDateLoaded) return const SizedBox.shrink();

        final currentAdj = state.date.adjustment;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.hijriAdjustmentBottomSheetTitle,
              style: AppTextStyles.font18W700White(context),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.v24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final adj in [-1, 0, 1])
                  _AdjustmentButton(
                    label: adj > 0 ? '+$adj' : '$adj',
                    isSelected: currentAdj == adj,
                    onTap: () {
                      unawaited(
                        context.read<AppDateCubit>().setAdjustment(adj),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.v24),
            TextButton(
              onPressed: () {
                unawaited(context.read<AppDateCubit>().resetAdjustment());
                Navigator.of(context).pop();
              },
              child: Text(
                AppStrings.hijriAdjustmentBottomSheetReturnToNormal,
                style: currentAdj != 0
                    ? AppTextStyles.font14W700primary(context)
                    : AppTextStyles.font14W700Grey(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AdjustmentButton extends StatelessWidget {
  const _AdjustmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.v24,
          vertical: AppSpacing.v12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.secondaryBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.3),
            width: AppSpacing.v2,
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTextStyles.font16W700Black(context)
              : AppTextStyles.font16W700White(context),
        ),
      ),
    );
  }
}



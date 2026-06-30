import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/cubit/app_date_state.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

class HijriAdjustmentBottomSheet extends StatelessWidget {
  const HijriAdjustmentBottomSheet({super.key});

  static const _adjustments = [-1, 0, 1];

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.v32,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.hijriAdjustmentBottomSheetTitle,
          style: AppTextStyles.font14W700(
            context,
          ),
          textAlign: TextAlign.center,
        ),
        BlocBuilder<AppDateCubit, AppDateState>(
          builder: (context, state) {
            if (state.date == null) return const SizedBox.shrink();
            final currentAdj = state.date!.adjustment;

            return Column(
              spacing: AppSpacing.v32,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final adj in _adjustments)
                      _AdjustmentButton(
                        label: adj > 0 ? '+$adj' : '$adj',
                        isSelected: currentAdj == adj,
                        onTap: () {
                          unawaited(
                            context.read<AppDateCubit>().setAdjustment(adj),
                          );
                          context.pop();
                        },
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    unawaited(context.read<AppDateCubit>().resetAdjustment());
                    context.pop();
                  },
                  child: Text(
                    AppStrings.hijriAdjustmentBottomSheetReturnToNormal,
                    style: currentAdj != 0
                        ? AppTextStyles.font14W700(context)
                        : AppTextStyles.font14W700(
                            context,
                          ).copyWith(color: context.color.textSecondary),
                  ),
                ),
              ],
            );
          },
        ),
      ],
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.v24,
          vertical: AppSpacing.v12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.primary
              : context.color.secondaryScaffoldBackgroundColor.withValues(
                  alpha: 0.5,
                ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusS),
          border: Border.all(
            color: isSelected
                ? context.color.primary
                : context.color.textSecondary.withValues(alpha: 0.3),
            width: AppSpacing.v2,
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppTextStyles.font14W700(
                  context,
                ).copyWith(color: context.color.scaffoldBackgroundColor)
              : AppTextStyles.font14W700(context),
        ),
      ),
    );
  }
}

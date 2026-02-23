import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_state.dart';

class HijriAdjustmentBottomSheet extends StatelessWidget {
  const HijriAdjustmentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDateCubit, AppDateState>(
      builder: (context, state) {
        final currentAdj = state.date.adjustment;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'تعديل التاريخ الهجري',
              style: AppTextStyles.font18W700White(context),
            ),
            const SizedBox(height: 8),
            Text(
              'يمكنك تصحيح التاريخ يدويًا إذا وجد اختلاف في بلدك',
              style: AppTextStyles.font14W400Grey(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                unawaited(context.read<AppDateCubit>().resetAdjustment());
                Navigator.pop(context);
              },
              child: Text(
                'العودة للتاريخ الطبيعي',
                style: AppTextStyles.font12W600primary(context).copyWith(
                  color: currentAdj != 0 ? AppColors.gold : AppColors.grey,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold
              : AppColors.secondaryBackground.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.gold
                : AppColors.grey.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.font16W700White(context).copyWith(
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

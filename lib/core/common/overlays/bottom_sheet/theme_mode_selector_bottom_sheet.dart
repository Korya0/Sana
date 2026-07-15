import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/cubit/app_cubit.dart';
import 'package:sana/core/cubit/app_state.dart';
import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';

class ThemeModeSelectorBottomSheet extends StatelessWidget {
  const ThemeModeSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.themeModeLabel,
              style: AppTextStyles.font16W700(context)
                  .copyWith(color: context.color.textPrimary),
              textAlign: TextAlign.center,
            ),
            const AppGap.h(AppSpacing.v24),
            AppSelectionCard(
              title: AppStrings.themeModeSystem,
              isSelected: state.themeMode == ThemeMode.system,
              onTap: () {
                unawaited(
                  context.read<AppCubit>().setThemeMode(ThemeMode.system),
                );
                AppNavigator.pop(context);
              },
            ),
            const AppGap.h(AppSpacing.v12),
            AppSelectionCard(
              title: AppStrings.themeModeLight,
              isSelected: state.themeMode == ThemeMode.light,
              onTap: () {
                unawaited(
                  context.read<AppCubit>().setThemeMode(ThemeMode.light),
                );
                AppNavigator.pop(context);
              },
            ),
            const AppGap.h(AppSpacing.v12),
            AppSelectionCard(
              title: AppStrings.themeModeDark,
              isSelected: state.themeMode == ThemeMode.dark,
              onTap: () {
                unawaited(
                  context.read<AppCubit>().setThemeMode(ThemeMode.dark),
                );
                AppNavigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

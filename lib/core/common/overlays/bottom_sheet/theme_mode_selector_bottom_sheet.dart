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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.v24,
                vertical: AppSpacing.v8,
              ),
              child: Text(
                AppStrings.themeModeLabel,
                style: AppTextStyles.font16W700(context)
                    .copyWith(color: context.color.textPrimary),
                textAlign: TextAlign.right,
              ),
            ),
            const CustomAppDivider(),
            _ThemeOptionTile<ThemeMode>(
              value: ThemeMode.system,
              selected: state.themeMode == ThemeMode.system,
              label: AppStrings.themeModeSystem,
              onSelect: () {
                unawaited(
                  context.read<AppCubit>().setThemeMode(ThemeMode.system),
                );
                AppNavigator.pop(context);
              },
            ),
            _ThemeOptionTile<ThemeMode>(
              value: ThemeMode.light,
              selected: state.themeMode == ThemeMode.light,
              label: AppStrings.themeModeLight,
              onSelect: () {
                unawaited(
                  context.read<AppCubit>().setThemeMode(ThemeMode.light),
                );
                AppNavigator.pop(context);
              },
            ),
            _ThemeOptionTile<ThemeMode>(
              value: ThemeMode.dark,
              selected: state.themeMode == ThemeMode.dark,
              label: AppStrings.themeModeDark,
              onSelect: () {
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

class _ThemeOptionTile<T> extends StatelessWidget {
  const _ThemeOptionTile({
    required this.value,
    required this.selected,
    required this.label,
    required this.onSelect,
  });

  final T value;
  final bool selected;
  final String label;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? context.color.primary : context.color.textSecondary,
      ),
      title: Text(
        label,
        style: AppTextStyles.font14W700(context)
            .copyWith(color: context.color.textPrimary),
      ),
      onTap: onSelect,
    );
  }
}

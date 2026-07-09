import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

class ScreenAwakeSection extends StatelessWidget {
  const ScreenAwakeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingSettingsCubit>();

    return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
      builder: (context, state) {
        final keepAwake =
            state is ReadingSettingsLoaded && state.settings.keepScreenAwake;

        return Semantics(
          label: AppStrings.keepScreenAwakeTitle,
          value: keepAwake ? 'مفعّل' : 'معطّل',
          hint: 'انقر مرتين للتفعيل أو التعطيل',
          excludeSemantics: true,
          child: SwitchListTile.adaptive(
            title: Text(
              AppStrings.keepScreenAwakeTitle,
              style: AppTextStyles.font14W700(context).copyWith(
                color: context.color.textPrimary,
              ),
            ),
            value: keepAwake,
            activeTrackColor: context.color.primary.withValues(alpha: 0.5),
            activeThumbColor: context.color.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              cubit.toggleScreenAwake();
              unawaited(cubit.saveSettings());
            },
          ),
        );
      },
    );
  }
}

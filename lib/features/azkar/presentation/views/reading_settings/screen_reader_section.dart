import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_state.dart';

class ScreenReaderSection extends StatelessWidget {
  const ScreenReaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadingSettingsCubit>();

    return BlocBuilder<ReadingSettingsCubit, ReadingSettingsState>(
      builder: (context, state) {
        final (screenReaderEnabled, isSupported) = state is ReadingSettingsLoaded
            ? (state.settings.screenReaderEnabled, state.isScreenReaderSupported)
            : (false, true);

        return Semantics(
          label: AppStrings.screenReaderTitle,
          value: screenReaderEnabled ? 'مفعّل' : 'معطّل',
          hint: isSupported ? 'انقر مرتين للتفعيل أو التعطيل' : 'قارئ الشاشة غير متوفر على هذا الجهاز',
          excludeSemantics: true,
          child: SwitchListTile.adaptive(
            title: Text(
              AppStrings.screenReaderTitle,
              style: AppTextStyles.font14W700(context).copyWith(
                color: isSupported
                    ? context.color.textPrimary
                    : context.color.textSecondary,
              ),
            ),
            subtitle: isSupported
                ? null
                : Text(
                    AppStrings.screenReaderNotAvailable,
                    style: AppTextStyles.font12W500(context).copyWith(
                      color: context.color.textSecondary,
                    ),
                  ),
            value: screenReaderEnabled,
            activeTrackColor: context.color.primary.withValues(alpha: 0.5),
            activeThumbColor: context.color.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: isSupported
                ? (value) {
                    cubit.toggleScreenReader();
                    unawaited(cubit.saveSettings());
                  }
                : null,
          ),
        );
      },
    );
  }
}

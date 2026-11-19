import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/app_haptics.dart';
import 'package:sana/features/azkar/presentation/cubits/common/counter_increment_result.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';

// Plays haptics for an increment result
void playIncrementHapticFeedback(
  BuildContext context,
  CounterIncrementResult result,
) {
  if (result is CounterIgnored) return;

  final enabled = context
      .read<AzkarTasbeehSettingsCubit>()
      .state
      .settingsOrDefault
      .hapticFeedbackEnabled;
  if (!enabled) return;

  unawaited(AppHaptics.light());
  if (result is CounterCompleted) unawaited(AppHaptics.doubleTap());
}

// Plays haptics for a successful decrement
void playDecrementHapticFeedback(BuildContext context) {
  final enabled = context
      .read<AzkarTasbeehSettingsCubit>()
      .state
      .settingsOrDefault
      .hapticFeedbackEnabled;
  if (!enabled) return;

  unawaited(AppHaptics.light());
}

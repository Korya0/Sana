import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/azkar_tasbeeh_settings_bottom_sheet.dart';

class AzkarSettingsFlow {
  const AzkarSettingsFlow._();

  static Future<void> openWithGoBack(
    BuildContext context, {
    required Future<void> Function() reopenOptions,
  }) async {
    final goBack = await AppBottomSheet.show<bool>(
      context: context,
      child: AzkarTasbeehSettingsBottomSheet(
        cubit: context.read<AzkarTasbeehSettingsCubit>(),
        showBackButton: true,
      ),
    );
    if (goBack != true || !context.mounted) return;
    await reopenOptions();
  }
}

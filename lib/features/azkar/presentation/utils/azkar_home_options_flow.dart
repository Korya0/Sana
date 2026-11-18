import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/widgets/overlays/app_bottom_sheet.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/utils/azkar_settings_flow.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_home_options_bottom_sheet.dart';

class AzkarHomeOptionsFlow {
  const AzkarHomeOptionsFlow._();

  static Future<void> open(BuildContext context) async {
    final option = await AppBottomSheet.show<AzkarHomeOption>(
      context: context,
      child: AzkarHomeOptionsBottomSheet(
        azkarTasbeehSettingsCubit: context.read<AzkarTasbeehSettingsCubit>(),
      ),
    );
    if (!context.mounted || option == null) return;

    switch (option) {
      case AzkarHomeOption.fontSize:
        await AzkarSettingsFlow.openWithGoBack(
          context,
          reopenOptions: () => open(context),
        );
      case AzkarHomeOption.manageCustomAzkar:
        await context.pushNamed(AppRoutes.customAzkarView);
        if (context.mounted) {
          unawaited(context.read<AzkarCategoriesCubit>().loadCategories());
        }
    }
  }
}

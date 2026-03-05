import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_cubit.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_state.dart';
import 'package:sana/features/app_update/presentation/widgets/force_update_overlay.dart';
import 'package:sana/features/app_update/presentation/widgets/optional_update_banner.dart';

class UpdateOverlay extends StatelessWidget {
  const UpdateOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUpdateCubit, AppUpdateState>(
      buildWhen: (previous, current) =>
          previous.isUpdateRequired != current.isUpdateRequired ||
          previous.config != current.config,
      builder: (context, state) {
        if (!state.isUpdateRequired || state.config == null) {
          return const SizedBox.shrink();
        }

        final config = state.config!;

        if (config.isForceUpdate) {
          return ForceUpdateOverlay(
            message: config.updateMessage ?? AppStrings.appUpdateMessage,
          );
        }

        return const OptionalUpdateBanner();
      },
    );
  }
}

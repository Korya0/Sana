import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:sana/core/services/app_update/presentation/cubit/app_update_state.dart';
import 'package:sana/core/services/app_update/presentation/widgets/force_update_overlay.dart';
import 'package:sana/core/services/app_update/presentation/widgets/optional_update_banner.dart';

class UpdateOverlay extends StatelessWidget {
  const UpdateOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUpdateCubit, AppUpdateState>(
      buildWhen: (previous, current) =>
          previous.isUpdateAvailable != current.isUpdateAvailable ||
          previous.isForceUpdateRequired != current.isForceUpdateRequired ||
          previous.config != current.config,
      builder: (context, state) {
        if (!state.isUpdateAvailable || state.config == null) {
          return const SizedBox.shrink();
        }

        final config = state.config!;

        if (state.isForceUpdateRequired) {
          return ForceUpdateOverlay(message: config.updateMessage ?? '');
        } else {
          return OptionalUpdateBanner(message: config.updateMessage);
        }
      },
    );
  }
}

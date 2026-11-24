import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/loading_skeleton.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_compass_content.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_state_content.dart';

class QiblaView extends StatelessWidget {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<QiblaCubit>(
    create: (_) {
      final cubit = sl<QiblaCubit>();
      unawaited(cubit.initialize());
      return cubit;
    },
    child: const _QiblaViewContent(),
  );
}

class _QiblaViewContent extends StatelessWidget {
  const _QiblaViewContent();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        // Header
        CommonSliverAppBar(
          title: AppStrings.qiblaHeader,
          showBack: true,
          onBackPressed: () => context.pop(),
        ),
        // Body
        SliverLayoutBuilder(
          builder: (context, sliverConstraints) {
            // The app bar consumes the top of the viewport. Pass the remaining
            // sliver extent to the state views so they centre inside it instead
            // of forcing a full-screen height that inflates the outer scroll.
            final fillHeight = sliverConstraints.remainingPaintExtent;
            return SliverFillRemaining(
              hasScrollBody: false,
              child: BlocBuilder<QiblaCubit, QiblaState>(
                builder: (context, state) => switch (state) {
                  QiblaInitial() ||
                  QiblaLoading() => const QiblaLoadingSkeleton(),
                  QiblaPermission() => QiblaStateContent(
                    icon: AppIcons.location,
                    iconColor: context.color.iconBrand,
                    title: AppStrings.qiblaPermissionTitle,
                    points: const [
                      AppStrings.qiblaPermissionStep1,
                      AppStrings.qiblaPermissionStep2,
                    ],
                    buttonLabel: AppStrings.qiblaAllow,
                    onButtonPressed: context
                        .read<QiblaCubit>()
                        .requestPermission,
                    fillHeight: fillHeight,
                  ),
                  QiblaCompass() => QiblaCompassContent(state: state),
                  QiblaDenied() => QiblaStateContent(
                    icon: AppIcons.locationOff,
                    iconColor: context.color.errorText,
                    title: AppStrings.qiblaDeniedTitle,
                    points: const [
                      AppStrings.qiblaDeniedStep1,
                      AppStrings.qiblaDeniedStep2,
                      AppStrings.qiblaDeniedStep3,
                      AppStrings.qiblaDeniedStep4,
                    ],
                    buttonLabel: AppStrings.qiblaOpenSettings,
                    onButtonPressed: context.read<QiblaCubit>().openAppSettings,
                    fillHeight: fillHeight,
                  ),
                  QiblaFailed() => QiblaStateContent(
                    icon: AppIcons.gpsNotFixed,
                    iconColor: context.color.iconBrand,
                    title: AppStrings.qiblaFailedTitle,
                    points: const [
                      AppStrings.qiblaFailedStep1,
                      AppStrings.qiblaFailedStep2,
                    ],
                    buttonLabel: AppStrings.qiblaOpenLocationSettings,
                    onButtonPressed: context
                        .read<QiblaCubit>()
                        .openLocationSettings,
                    fillHeight: fillHeight,
                  ),
                  QiblaUnsupported() => QiblaStateContent(
                    icon: AppIcons.compass,
                    iconColor: context.color.iconSecondary,
                    title: AppStrings.qiblaUnsupportedTitle,
                    points: const [AppStrings.qiblaUnsupportedMessage],
                    buttonLabel: AppStrings.back,
                    onButtonPressed: () => context.pop(),
                    fillHeight: fillHeight,
                  ),
                },
              ),
            );
          },
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/overlays/dialog/custom_info_dialog.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_view_loaded_widget.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qiblaview.dart';
import 'package:solar_icons/solar_icons.dart';

Future<void> showQiblaHelpDialog(BuildContext context) async {
  await showCustomInfoDialog(
    context: context,
    title: AppStrings.qiblaCompassGuidelines,
    warningIcon: SolarIconsBold.dangerTriangle,
    warningText: AppStrings.qiblaCompassNoSensor,
    instructionsTitle: AppStrings.qiblaBestAccuracy,
    instructions: [
      AppStrings.qiblaGuideline1,
      AppStrings.qiblaGuideline2,
      AppStrings.qiblaGuideline3,
    ],
  );
}

class QiblaView extends StatefulWidget {
  const QiblaView({super.key});

  @override
  State<QiblaView> createState() => _QiblaViewState();
}

class _QiblaViewState extends State<QiblaView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<QiblaCubit>()..initQibla(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            CommonSliverAppBar(
              title: AppStrings.qiblaDirection,
              actions: [
                IconButton(
                  onPressed: () async {
                    await showQiblaHelpDialog(context);
                  },
                  icon: const Icon(
                    SolarIconsBold.lightbulb,
                    color: AppColors.iconPrimary,
                  ),
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: BlocBuilder<QiblaCubit, QiblaState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => const SizedBox.shrink(),
                    loading: (_) => const SkeletonizerQiblaview(),
                    error: (s) => AppErrorView(
                      message: AppStrings.qiblaErrorLoad,
                      onRetry: () => context.read<QiblaCubit>().initQibla(),
                    ),
                    loaded: (s) => QiblaViewLoadedWidget(
                      state: s,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

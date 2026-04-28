import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/cubit/qibla_state.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_view_loaded_widget.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_scaffold.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qibla_widget.dart';

class QiblaView extends StatelessWidget {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<QiblaCubit>()..initQibla(),
      child: QiblaScaffold(
        body: BlocBuilder<QiblaCubit, QiblaState>(
          builder: (context, state) {
            return switch (state) {
              QiblaInitial() => const SizedBox.shrink(),
              QiblaLoading() => const SkeletonizerQiblaWidget(),
              QiblaError(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context.read<QiblaCubit>().initQibla(),
                ),
              QiblaSuccess() => QiblaViewLoadedWidget(state: state),
            };
          },
        ),
      ),
    );
  }
}

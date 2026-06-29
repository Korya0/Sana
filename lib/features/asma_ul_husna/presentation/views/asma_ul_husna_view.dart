import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/skeletonizer_loading_asma_ul_husna_view.dart';

class AsmaUlHusnaView extends StatelessWidget {
  const AsmaUlHusnaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<AsmaUlHusnaCubit>();
        unawaited(cubit.loadNames());
        return cubit;
      },
      child: Scaffold(
        body: BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CommonSliverAppBar(title: AppStrings.asmaUlHusna),
                if (state is AsmaUlHusnaLoading) ...[
                  const SkeletonizerLoadingAsmaUlHusnaView(),
                ] else if (state is AsmaUlHusnaError) ...[
                  SliverFillRemaining(
                    child: AppErrorView(
                      message: state.message,
                      onRetry: () => unawaited(
                        context.read<AsmaUlHusnaCubit>().loadNames(),
                      ),
                    ),
                  ),
                ] else if (state is AsmaUlHusnaLoaded) ...[
                  AnimatedSliverList<AsmaulHusnaModel>(
                    dataList: state.names,
                    itemContentBuilder: (context, name, index) =>
                        AsmaUlHusnaCard(name: name),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

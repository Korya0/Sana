import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_clipboard.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_share.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_card.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_share_card.dart';
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
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const CommonSliverAppBar(title: AppStrings.asmaUlHusna),
            BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SkeletonizerLoadingAsmaUlHusnaView(),
                  loading: () => const SkeletonizerLoadingAsmaUlHusnaView(),
                  loaded: (names) => AnimatedSliverList<AsmaUlHusnaEntity>(
                    dataList: names,
                    itemContentBuilder: (context, name, index) => AsmaUlHusnaCard(
                      name: name,
                      onSharePressed: () => AppShare.shareWidgetAsImage(
                        context: context,
                        widget: AsmaUlHusnaShareCard(name: name),
                        imageName: 'share_asma_${name.id}',
                      ),
                      onCopyPressed: () => AppClipboard.copy(
                        context: context,
                        text:
                            '${name.name}\n${name.meaningBrief}\n\n${name.meaningDetailed}',
                      ),
                    ),
                  ),
                  error: (message) => SliverFillRemaining(
                    child: AppErrorView(
                      message: message,
                      onRetry: () => unawaited(
                        context.read<AsmaUlHusnaCubit>().loadNames(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

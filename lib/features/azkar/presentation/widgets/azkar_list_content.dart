import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/slivers/app_sliver_list.dart';
import 'package:sana/core/widgets/views/app_empty_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_list_skeleton.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart';

class AzkarListContent extends StatelessWidget {
  const AzkarListContent({
    required this.onRetry,
    super.key,
    this.onItemCompleted,
  });

  final VoidCallback onRetry;
  final void Function(int index)? onItemCompleted;

  @override
  Widget build(BuildContext context) => BlocBuilder<AzkarCubit, AzkarState>(
    buildWhen: (previous, current) =>
        previous.runtimeType != current.runtimeType,
    builder: (context, state) => switch (state) {
      AzkarLoading() || AzkarInitial() => const AzkarListSkeleton(),
      AzkarError(:final message) => SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorView(message: message, onRetry: onRetry),
      ),
      AzkarEmpty() => const SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyView(message: AppStrings.azkarEmpty),
      ),
      AzkarLoaded(:final azkar) => SliverMainAxisGroup(
        slivers: [
          AppSliverList(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              final zikr = azkar[index];

              return ZikrItemCard(
                zikr: zikr,
                onCompleted: () => onItemCompleted?.call(index),
              );
            },
          ),
          SliverToBoxAdapter(child: AppGap.h(AppSize.p32)),
        ],
      ),
    },
  );
}

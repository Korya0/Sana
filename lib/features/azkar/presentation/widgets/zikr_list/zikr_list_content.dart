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
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_card/zikr_item_card.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_list/zikr_list_skeleton.dart';

class ZikrListContent extends StatelessWidget {
  const ZikrListContent({
    required this.onRetry,
    required this.categoryKey,
    super.key,
    this.onItemCompleted,
    this.cardKeyBuilder,
  });

  final String categoryKey;
  final VoidCallback onRetry;
  final void Function(int index)? onItemCompleted;
  final Key? Function(int index)? cardKeyBuilder;

  @override
  Widget build(BuildContext context) => BlocBuilder<AzkarCubit, AzkarState>(
    buildWhen: (previous, current) {
      if (previous.runtimeType != current.runtimeType) return true;
      if (previous is AzkarLoaded && current is AzkarLoaded) {
        return !identical(previous.azkar, current.azkar) ||
            previous.azkar.length != current.azkar.length;
      }
      return false;
    },
    builder: (context, state) => switch (state) {
      AzkarLoading() || AzkarInitial() => const ZikrListSkeleton(),
      AzkarError(:final message) => SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorView(message: message, onRetry: onRetry),
      ),
      AzkarEmpty() => const SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyView(message: AppStrings.azkarEmpty),
      ),
      AzkarLoaded(:final azkar, :final resolvedTitle) => SliverMainAxisGroup(
        slivers: [
          // Body
          AppSliverList(
            padding: AppSize.shp,
            itemCount: azkar.length,
            itemBuilder: (context, index) {
              final zikr = azkar[index];

              return ZikrItemCard(
                key: cardKeyBuilder?.call(index),
                zikr: zikr,
                categoryTitle: resolvedTitle,
                onCounterCompleted: () => onItemCompleted?.call(index),
              );
            },
          ),
          // Bottom gap
          SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
        ],
      ),
    },
  );
}

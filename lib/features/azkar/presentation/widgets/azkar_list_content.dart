import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/features/sharing/presentation/utils/app_clipboard.dart';
import 'package:sana/features/sharing/presentation/utils/app_share.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/widgets/share_card/zikr_share_card.dart';
import 'package:sana/features/azkar/presentation/widgets/skeletonizer_azkar_list.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart';

class AzkarListContent extends StatelessWidget {
  const AzkarListContent({super.key, this.onItemCompleted});

  final void Function(int index)? onItemCompleted;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        if (state is AzkarLoading) {
          return const SkeletonizerAzkarList();
        } else if (state is AzkarError) {
          return SliverToBoxAdapter(
            child: AppErrorView(
              message: state.message,
            ),
          );
        } else if (state is AzkarLoaded) {
          return AnimatedSliverList<ZikrEntity>(
            dataList: state.azkar,
            keyFinder: (zikr, index) => ValueKey('zikr_${zikr.id}'),
            itemContentBuilder: (context, zikr, index) => ZikrItemCard(
              zikr: zikr,
              index: index,
              onCompleted: () => onItemCompleted?.call(index),
              onSharePressed: () => AppShare.shareWidgetAsImage(
                context: context,
                widget: ZikrShareCard(
                  text: zikr.text,
                  subText: zikr.description,
                ),
                imageName: 'zikr_share',
              ),
              onCopyPressed: () => AppClipboard.copy(
                context: context,
                text: zikr.text,
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

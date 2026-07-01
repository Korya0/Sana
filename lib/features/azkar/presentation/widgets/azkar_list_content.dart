import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_clipboard.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_share.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/widgets/share_card/zikr_share_card.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_item_card.dart';

class AzkarListContent extends StatelessWidget {
  const AzkarListContent({
    required this.category,
    required this.onCompleted,
    super.key,
  });
  final AzkarCategoryEntity category;
  final ValueChanged<int> onCompleted;

  @override
  Widget build(BuildContext context) {
    return AnimatedSliverList<ZikrEntity>(
      dataList: category.array,
      keyFinder: (zikr, index) => ValueKey('zikr_${category.id}_$index'),
      itemContentBuilder: (context, zikr, index) => ZikrItemCard(
        zikr: zikr,
        index: index,
        onCompleted: () => onCompleted(index),
        onSharePressed: () => AppShare.shareWidgetAsImage(
          context: context,
          widget: ZikrShareCard(
            text: zikr.text,
            subText: zikr.subText,
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
}

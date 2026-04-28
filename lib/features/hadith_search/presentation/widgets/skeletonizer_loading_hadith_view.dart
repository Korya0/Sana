import 'package:flutter/material.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_item_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerLoadingHadithView extends StatelessWidget {
  const SkeletonizerLoadingHadithView({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate dummy data for the skeleton
    final dummyList = List.generate(
      10,
      (index) => const HadithModel(
        hadithContent: '''
          <div class="hadith-body">نص الحديث الشريف يظهر هنا كعنصر نائب أثناء التحميل، ويحتوي على عدة أسطر لملء المساحة بشكل مناسب.</div>
          <div class="divider"></div>
          <div class="info-row"><span class="lbl">الراوي:</span> -------- | <span class="lbl">المحدث:</span> --------</div>
          <div class="info-row"><span class="lbl">المصدر:</span> -------- | <span class="lbl">الصفحة:</span> ---</div>
          <div class="judgment-row">
            <span class="judgment-label">خلاصة حكم المحدث:</span> 
            <span class="judgment-value">---------</span>
          </div>
        ''',
      ),
    );

    return Skeletonizer.sliver(
      child: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return HadithItemCard(hadith: dummyList[index]);
        }, childCount: dummyList.length),
      ),
    );
  }
}

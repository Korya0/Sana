import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/services/zakat_calculator.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_info_card.dart';

class ResultExplanationCard extends StatelessWidget {
  const ResultExplanationCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    return ZakatInfoCard(
      child: Text(
        _explanation(result),
        style: const TextStyle(fontSize: 16, height: 1.8),
      ),
    );
  }

  static String _explanation(ZakatResult r) {
    final net = NumberUtils.formatMoney(r.netAmount);
    switch (r.status) {
      case ZakatStatus.due:
        return 'صافي مالك $net، وهو يبلغ النصاب '
            '(${NumberUtils.formatMoney(r.nisabValue!)}) وقد مر عليه الحول.\n'
            'الزكاة التقديرية = $net × 2.5% = '
            '${NumberUtils.formatMoney(r.zakatAmount)}.';
      case ZakatStatus.belowNisab:
        return 'صافي مالك $net، وهو أقل من النصاب '
            '(${NumberUtils.formatMoney(r.nisabValue!)})، '
            'فلا تجب عليك الزكاة بحسب البيانات المدخلة.';
      case ZakatStatus.hawlNotCompleted:
        return 'صافي مالك $net، وهو يبلغ النصاب '
            '(${NumberUtils.formatMoney(r.nisabValue!)})، لكن لم يتم الحول '
            'بعد، فلا تجب الزكاة الآن.';
      case ZakatStatus.nisabUnknown:
        return 'القيمة المحسوبة من البيانات المتاحة $net (قد تكون ناقصة). '
            'لم يتم إدخال سعر المعدن اللازم، فلا يمكن تقدير النصاب بدقة. '
            'نسبة الزكاة شرعاً هي ${ZakatCalculator.rate * 100}%.';
    }
  }
}

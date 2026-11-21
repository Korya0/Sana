import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_info_card.dart';
import '../zakat_result_row.dart';

class AssetsBreakdownCard extends StatelessWidget {
  const AssetsBreakdownCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final input = result.input;
    final nisabText = result.nisabValue == null
        ? 'غير محدد'
        : NumberUtils.formatMoney(result.nisabValue!);

    return ZakatInfoCard(
      child: Column(
        children: [
          ZakatResultRow(
            label: 'إجمالي الأموال',
            value: NumberUtils.formatMoney(result.totalAssets),
          ),
          ZakatResultRow(
            label: 'الخصومات المطبّقة',
            value: result.appliedDeductions > 0
                ? '- ${NumberUtils.formatMoney(result.appliedDeductions)}'
                : NumberUtils.formatMoney(0),
          ),
          const Divider(),
          ZakatResultRow(
            label: result.status == ZakatStatus.nisabUnknown
                ? 'صافي المال (تقديري)'
                : 'صافي المال',
            value: NumberUtils.formatMoney(result.netAmount),
            bold: true,
          ),
          const Divider(),
          _subHeader(primary, 'المعادن'),
          ZakatResultRow(
            label: 'قيمة الذهب',
            value: NumberUtils.formatMoney(result.goldValue),
          ),
          if (input.goldGrams > 0)
            ZakatResultRow(
              label: 'وزن الذهب',
              value:
                  '${NumberUtils.formatAmount(input.goldGrams)} جرام (عيار ${input.goldKarat})',
            ),
          ZakatResultRow(
            label: 'قيمة الفضة',
            value: NumberUtils.formatMoney(result.silverValue),
          ),
          if (input.silverGrams > 0)
            ZakatResultRow(
              label: 'وزن الفضة',
              value: '${NumberUtils.formatAmount(input.silverGrams)} جرام',
            ),
          const Divider(),
          _subHeader(primary, 'النصاب'),
          ZakatResultRow(
            label: 'المعيار المعتمد',
            value: 'نصاب ${input.standard.label}',
          ),
          ZakatResultRow(label: 'قيمة النصاب', value: nisabText),
          ZakatResultRow(
            label: 'تمام الحول',
            value: input.hawlCompleted ? 'نعم' : 'لا',
          ),
        ],
      ),
    );
  }

  Widget _subHeader(Color color, String text) => Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 4),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ),
  );
}

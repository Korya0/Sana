import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_money_field.dart';

class OtherAssetsSection extends StatelessWidget {
  const OtherAssetsSection({
    super.key,
    required this.cashController,
    required this.silverGramsController,
    required this.silverPriceController,
    required this.tradeController,
    required this.receivableController,
  });

  final TextEditingController cashController;
  final TextEditingController silverGramsController;
  final TextEditingController silverPriceController;
  final TextEditingController tradeController;
  final TextEditingController receivableController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZakatMoneyField(
          controller: cashController,
          label: 'الأموال النقدية والمدخرات',
          helper: 'النقد الذي معك والأرصدة في البنك وحسابات التوفير.',
        ),
        const SizedBox(height: 14),
        ZakatMoneyField(
          controller: silverGramsController,
          label: 'وزن الفضة بالجرام',
          helper: 'أدخل وزن الفضة النقية التي تملكها، إن وجدت.',
          suffix: 'جرام',
        ),
        ListenableBuilder(
          listenable: Listenable.merge([
            silverGramsController,
            silverPriceController,
          ]),
          builder: (context, _) {
            final weight =
                NumberUtils.parseAmount(silverGramsController.text) ?? 0;
            final price =
                NumberUtils.parseAmount(silverPriceController.text) ?? 0;
            if (weight <= 0 || price <= 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'قيمة الفضة: ${NumberUtils.formatAmount(weight)} × '
                '${NumberUtils.formatAmount(price)} = ${NumberUtils.formatMoney(weight * price)}',
                style: const TextStyle(fontSize: 14.5, height: 1.6),
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        ZakatMoneyField(
          controller: tradeController,
          label: 'الأموال التجارية',
          helper: 'قيمة البضاعة المعدّة للبيع وسيولة التجارة.',
        ),
        const SizedBox(height: 14),
        ZakatMoneyField(
          controller: receivableController,
          label: 'ديون لك عند الآخرين يُرجى تحصيلها',
          helper: 'أدخل فقط الدين الذي ترجو سداده.',
        ),
      ],
    );
  }
}

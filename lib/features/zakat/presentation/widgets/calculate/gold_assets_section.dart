import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';
import '../zakat_money_field.dart';

class GoldAssetsSection extends StatelessWidget {
  const GoldAssetsSection({
    super.key,
    required this.goldGramsController,
    required this.goldPriceController,
    required this.goldKarat,
    required this.goldPersonal,
    required this.onGoldPersonalChanged,
    required this.includePersonalGold,
    required this.onIncludePersonalGoldChanged,
  });

  final TextEditingController goldGramsController;
  final TextEditingController goldPriceController;
  final int goldKarat;
  final bool goldPersonal;
  final ValueChanged<bool> onGoldPersonalChanged;
  final bool includePersonalGold;
  final ValueChanged<bool> onIncludePersonalGoldChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZakatMoneyField(
          controller: goldGramsController,
          label: 'وزن الذهب بالجرام (عيار $goldKarat)',
          helper: 'أدخل وزن الذهب الذي تملكه.',
          suffix: 'جرام',
        ),
        ListenableBuilder(
          listenable: Listenable.merge([
            goldGramsController,
            goldPriceController,
          ]),
          builder: (context, _) {
            final weight =
                NumberUtils.parseAmount(goldGramsController.text) ?? 0;
            final price =
                NumberUtils.parseAmount(goldPriceController.text) ?? 0;
            if (weight <= 0 || price <= 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'قيمة الذهب: ${NumberUtils.formatAmount(weight)} × '
                '${NumberUtils.formatAmount(price)} = ${NumberUtils.formatMoney(weight * price)}',
                style: const TextStyle(fontSize: 14.5, height: 1.6),
              ),
            );
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('الذهب للاستعمال الشخصي (حلي ونحوه)'),
          subtitle: const Text(
            'زكاة الذهب المقتنى للاستعمال الشخصي فيها خلاف فقهي.',
          ),
          value: goldPersonal,
          onChanged: onGoldPersonalChanged,
        ),
        if (goldPersonal)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('أريد إدخاله في الحساب'),
            subtitle: const Text(
              'إن لم تفعّل الخيار يُستبعد الذهب الشخصي من الحساب.',
            ),
            value: includePersonalGold,
            onChanged: onIncludePersonalGoldChanged,
          ),
      ],
    );
  }
}

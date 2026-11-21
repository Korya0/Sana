import 'package:flutter/material.dart';
import '../zakat_info_card.dart';

class ExampleCard extends StatelessWidget {
  const ExampleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ZakatInfoCard(
      color: primary.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مثال بسيط',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'إذا كنت تملك 100 جرام من الذهب عيار 21، وكان سعر جرام عيار 21 '
            'هو 5,000 جنيه، فقيمة الذهب = 100 × 5,000 = 500,000 جنيه.\n'
            'وللتحقق من النصاب يُحوَّل الوزن إلى ما يعادله من الذهب الخالص: '
            '100 × 21 ÷ 24 = 87.5 جرامًا، وهو يبلغ نصاب الذهب (85 جرامًا). '
            'فإذا مر الحول على هذا المال، تكون الزكاة = 500,000 × 2.5% = '
            '12,500 جنيه.',
            style: TextStyle(fontSize: 16, height: 1.8),
          ),
        ],
      ),
    );
  }
}

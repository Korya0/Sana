import 'package:flutter/material.dart';
import '../zakat_info_card.dart';
import '../zakat_section_title.dart';

class WhatIsZakatCard extends StatelessWidget {
  const WhatIsZakatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZakatSectionTitle('ما هي الزكاة؟'),
          Text(
            'الزكاة عبادة مالية فرضها الله على المسلم القادر، فيُخرج جزءًا '
            'صغيرًا من ماله للمستحقين إذا بلغ المال النصاب وتحققت شروط '
            'الوجوب. وهي من أركان الإسلام الخمسة.',
            style: TextStyle(fontSize: 16, height: 1.8),
          ),
        ],
      ),
    );
  }
}

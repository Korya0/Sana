import 'package:flutter/material.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_card.dart';

class DailyHadithCard extends StatelessWidget {
  const DailyHadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DailyContentCard(type: DailyContentType.hadith);
  }
}

import 'package:flutter/material.dart';
import '../zakat_info_card.dart';

class QaCard extends StatelessWidget {
  const QaCard({super.key, required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ZakatInfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(answer, style: const TextStyle(fontSize: 16, height: 1.8)),
        ],
      ),
    );
  }
}

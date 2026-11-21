import 'package:flutter/material.dart';
import 'qa_card.dart';

class ExplainQaList extends StatelessWidget {
  const ExplainQaList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        QaCard(
          question: 'ما هي الزكاة؟',
          answer:
              'عبادة مالية فرضها الله على المسلمين المستحق عليهم إخراجها وفقًا لشروطها.',
        ),
        SizedBox(height: 12),
        QaCard(
          question: 'متى تجب؟',
          answer:
              'في الأموال التي تجب فيها الزكاة عند بلوغ النصاب وتحقق شروط الوجوب ومرور الحول.',
        ),
        SizedBox(height: 12),
        QaCard(
          question: 'ما هو النصاب؟',
          answer:
              'الحد الأدنى من المال الذي إذا بلغه وجبت الزكاة (85 جم ذهب خالص أو 595 جم فضة).',
        ),
        SizedBox(height: 12),
        QaCard(
          question: 'ما هو الحول؟',
          answer: 'أن تمر سنة هجرية كاملة على المال وهو بالغ للنصاب.',
        ),
        SizedBox(height: 12),
        QaCard(
          question: 'كم مقدار زكاة المال؟',
          answer:
              'ربع العشر، أي 2.5%، في الأموال التي ينطبق عليها هذا المقدار.',
        ),
      ],
    );
  }
}

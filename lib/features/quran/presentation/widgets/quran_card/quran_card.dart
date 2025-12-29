import 'package:flutter/material.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_actions.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_header.dart';

class QuranCard extends StatelessWidget {
  const QuranCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: QuranCardBackground.decoration,
      child: const Stack(
        children: [
          QuranCardBackground(),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [QuranCardHeader(), QuranCardActions()],
            ),
          ),
        ],
      ),
    );
  }
}

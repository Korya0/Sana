import 'package:flutter/material.dart';
import 'package:sana/features/home/presentation/widgets/sections/quran_card/quran_card_actions.dart';
import 'package:sana/features/home/presentation/widgets/sections/quran_card/quran_card_background.dart';
import 'package:sana/features/home/presentation/widgets/sections/quran_card/quran_card_header.dart';
import 'package:sana/features/home/presentation/widgets/sections/quran_card/quran_card_progress.dart';

class QuranCard extends StatelessWidget {
  const QuranCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: QuranCardBackground.decoration,
      child: Stack(
        children: [
          const QuranCardBackground(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                QuranCardHeader(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [QuranCardProgress(), QuranCardActions()],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

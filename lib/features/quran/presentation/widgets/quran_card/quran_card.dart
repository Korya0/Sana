import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_actions.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_background.dart';
import 'package:sana/features/quran/presentation/widgets/quran_card/quran_card_header.dart';

class QuranCard extends StatelessWidget {
  const QuranCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DailyContentCubit(context.read<AppDateCubit>())..loadDailyContent(),
      child: Container(
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
      ),
    );
  }
}

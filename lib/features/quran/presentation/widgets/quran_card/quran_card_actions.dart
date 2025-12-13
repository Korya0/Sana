import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';

import 'package:sana/features/home/presentation/cubit/daily_content_cubit.dart';

import 'package:sana/features/home/presentation/widgets/daily_content_dialog.dart';

class QuranCardActions extends StatelessWidget {
  const QuranCardActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        return Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _ActionButton(
              title: 'القرآن',
              onTap: () => context.pushNamed(AppRoutes.quran),
            ),
            _ActionButton(
              title: 'آية',
              onTap: () => _showVerseDialog(context, state),
            ),
            _ActionButton(
              title: 'حديث',
              onTap: () => _showHadithDialog(context, state),
            ),
            _ActionButton(
              title: 'سنة مهجورة',
              onTap: () => _showSunnahDialog(context, state),
            ),
          ],
        );
      },
    );
  }

  void _showVerseDialog(BuildContext context, DailyContentState state) {
    if (state.dailyVerse == null) return;

    showDialog(
      context: context,
      builder: (context) => DailyContentDialog(
        title: "آية من سورة ${state.dailyVerse!.surahName}",
        content: Column(
          children: [
            Text(
              state.dailyVerse!.text,
              style: AppTextStyles.font26W700GoldQuran(
                context,
              ).copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 12),
            Text(
              "سورة ${state.dailyVerse!.surahName} - آية ${state.dailyVerse!.ayahNumber}",
              style: AppTextStyles.font14W400Gold(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showHadithDialog(BuildContext context, DailyContentState state) {
    if (state.dailyHadith == null) return;
    showDialog(
      context: context,
      builder: (context) => DailyContentDialog(
        title: "حديث اليوم",
        content: Column(
          children: [
            Text(
              state.dailyHadith!.text,
              style: AppTextStyles.font16W600White(
                context,
              ).copyWith(height: 1.6),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 12),
            Text(
              state.dailyHadith!.narrator,
              style: AppTextStyles.font14W400Gold(context),
            ),
            SizedBox(height: 4),
            Text(
              state.dailyHadith!.source,
              style: AppTextStyles.font12W500WhiteDimmed(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showSunnahDialog(BuildContext context, DailyContentState state) {
    if (state.dailySunnah == null) return;
    showDialog(
      context: context,
      builder: (context) => DailyContentDialog(
        title: "سنة مهجورة",
        content: Column(
          children: [
            Text(
              state.dailySunnah!.text,
              style: AppTextStyles.font18W700Gold(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              state.dailySunnah!.description,
              style: AppTextStyles.font16W500White(
                context,
              ).copyWith(height: 1.5),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const _ActionButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: AppTextStyles.font12W600primary(
            context,
          ).copyWith(color: Colors.black, fontSize: 13),
        ),
      ),
    );
  }
}

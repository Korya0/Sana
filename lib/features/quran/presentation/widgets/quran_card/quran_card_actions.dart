import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/verse_hadith_sunnah_daily_content_dialog.dart';

class QuranCardActions extends StatelessWidget {
  const QuranCardActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        return Row(
          spacing: 16,
          children: [
            _ActionButton(
              title: 'القرآن الكريم',
              onTap: () => context.pushNamed(AppRoutes.quran),
            ),
            _ActionButton(
              title: 'حديث اليوم',
              onTap: () => showHadithDialog(context, state),
            ),
            _ActionButton(
              title: 'سنة اليوم',
              onTap: () => showSunnahDialog(context, state),
            ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.title, required this.onTap});
  final String title;
  final VoidCallback? onTap;
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

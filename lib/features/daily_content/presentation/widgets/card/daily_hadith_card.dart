import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_base_card.dart';

class DailyHadithCard extends StatelessWidget {
  const DailyHadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final hadith = state.dailyHadith;
        if (hadith == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          item: hadith,
          title: 'الحديث اليومي',
          icon: FlutterIslamicIcons.mohammad,
          isFavorite: state.isHadithFavorite,
          onFavoriteToggle: () =>
              context.read<DailyContentCubit>().toggleHadithFavorite(),
          onMarkViewed: () =>
              context.read<DailyContentCubit>().markHadithAsViewed(),
          shareImageName: 'daily_hadith_share',
          copySuccessMessage: 'تم نسخ الحديث بنجاح',
        );
      },
    );
  }
}

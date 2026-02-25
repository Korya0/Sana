import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_base_card.dart';

class DailySunnahCard extends StatelessWidget {
  const DailySunnahCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final sunnah = state.dailySunnah;
        if (sunnah == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          item: sunnah,
          title: 'سنة مهجورة',
          icon: FlutterIslamicIcons.prayer,
          isFavorite: state.isSunnahFavorite,
          onFavoriteToggle: () =>
              context.read<DailyContentCubit>().toggleSunnahFavorite(),
          onMarkViewed: () =>
              context.read<DailyContentCubit>().markSunnahAsViewed(),
          shareImageName: 'daily_sunnah_share',
          copySuccessMessage: 'تم نسخ المحتوى بنجاح',
        );
      },
    );
  }
}

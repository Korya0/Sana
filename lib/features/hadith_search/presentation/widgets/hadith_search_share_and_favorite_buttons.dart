import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/features/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/features/sharing/presentation/utils/app_share.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/share_card/hadith_share_card.dart';
import 'package:sana/features/hadith_search/utils/hadith_formatter.dart';

class HadithSearchShareAndFavoriteButtons extends StatelessWidget {
  const HadithSearchShareAndFavoriteButtons({required this.hadith, super.key});
  final HadithEntity hadith;

  Future<void> _copyHadith(BuildContext context) async {
    try {
      final text = HadithFormatter.formatForCopy(hadith.hadithContent);
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
    } on Object catch (e, stack) {
      unawaited(AppLogger.localError(
        'HadithSearch: Copy Error',
        error: e,
        stackTrace: stack,
      ));
      if (!context.mounted) return;
      AppToast.show(context, AppStrings.copyFailed, type: AppToastType.error);
    }
  }

  Future<void> _shareHadith(BuildContext context) async {
    if (!context.mounted) return;
    await AppShare.shareWidgetAsImage(
      context: context,
      widget: HadithShareCard(hadith: hadith),
      imageName: 'hadith_share',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<HadithFavoritesCubit, HadithFavoritesState>(
          builder: (context, state) {
            final isFav =
                state is HadithFavoritesLoaded && state.isFavorite(hadith);
            return CustomFavoriteToggleButton(
              onPressed: () {
                context.read<HadithFavoritesCubit>().toggleFavorite(hadith);
              },
              isFav: isFav,
            );
          },
        ),
        CombinedShareCopyButton(
          onSharePressed: () => _shareHadith(context),
          onCopyPressed: () => _copyHadith(context),
          iconSize: AppSpacing.s20.r(context),
        ),
      ],
    );
  }
}

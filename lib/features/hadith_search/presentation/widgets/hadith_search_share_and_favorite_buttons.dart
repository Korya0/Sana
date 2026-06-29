import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/core/services/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/cubit/hadith_favorites/hadith_favorites_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/share_card/hadith_share_card.dart';
import 'package:sana/features/hadith_search/utils/hadith_formatter.dart';

class HadithSearchShareAndFavoriteButtons extends StatelessWidget {
  const HadithSearchShareAndFavoriteButtons({required this.hadith, super.key});
  final HadithModel hadith;
  Future<void> _copyHadith(BuildContext context) async {
    final text = HadithFormatter.formatForCopy(hadith.hadithContent);
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _shareHadith(BuildContext context) async {
    await WidgetToImageHelper.shareWidget(
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
            final isFav = state.isFavorite(hadith);
            return CustomFavoriteToggleButton(
              onPressed: () {
                context.read<HadithFavoritesCubit>().toggleFavorite(hadith);
                FavoriteToast.showFavoriteToast(context, isAdded: !isFav);
              },
              isFav: isFav,
            );
          },
        ),
        CombinedShareCopyButton(
          onSharePressed: () => _shareHadith(context),
          onCopyPressed: () => _copyHadith(context),
          iconSize: AppSpacing.v20,
        ),
      ],
    );
  }
}

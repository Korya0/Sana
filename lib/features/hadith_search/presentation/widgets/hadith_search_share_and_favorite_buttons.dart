import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/favorites/custom_favorite_toggle_button.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/share_card/hadith_share_card.dart';
import 'package:sana/features/hadith_search/utils/hadith_formatter.dart';

class HadithSearchShareAndFavoriteButtons extends StatelessWidget {
  const HadithSearchShareAndFavoriteButtons({required this.hadith, super.key});
  final HadithEntity hadith;
  Future<void> _copyHadith(BuildContext context) async {
    final text = HadithFormatter.formatForCopy(hadith.hadithContent);
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      AppToast.show(context, AppStrings.copiedToClipboard);
    }
  }

  Future<void> _shareHadith(BuildContext context) async {
    await WidgetToImage.shareWidget(
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
              onPressed: () =>
                  context.read<HadithFavoritesCubit>().toggleFavorite(hadith),
              isFav: isFav,
            );
          },
        ),
        CombinedShareCopyButton(
          onSharePressed: () => _shareHadith(context),
          onCopyPressed: () => _copyHadith(context),
          iconSize: 20,
        ),
      ],
    );
  }
}

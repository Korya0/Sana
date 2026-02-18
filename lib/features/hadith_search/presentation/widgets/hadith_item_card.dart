import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithItemCard extends StatelessWidget {
  final HadithEntity hadith;
  final String? searchQuery;

  const HadithItemCard({super.key, required this.hadith, this.searchQuery});

  Future<void> _copyHadith(BuildContext context) async {
    // تنسيق النص قبل النسخ ليظهر بشكل منظم في الحافظة
    String text = hadith.hadithContent
        .replaceAll(RegExp(r'<div class="divider">.*?</div>'), '\n---\n')
        .replaceAll(RegExp(r'</div>'), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();

    // إزالة السطور الفارغة الزائدة
    text = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty || e == '---')
        .join('\n');

    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      AppToast.show(context, 'تم نسخ الحديث بنجاح');
    }
  }

  Future<void> _shareHadith(BuildContext context) async {
    await WidgetToImage.shareWidget(
      context: context,
      widget: HadithShareCard(content: hadith.hadithContent),
      imageName: 'hadith_share',
    );
  }

  @override
  Widget build(BuildContext context) {
    String content = hadith.hadithContent;

    // تمييز كلمة البحث مع تجاهل التشكيل بشكل آمن (لا يكسر الـ HTML)
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      final query = searchQuery!.trim();
      const diacritics = '[\u064B-\u0652]*';
      final String regexPattern = query
          .split('')
          .map((char) => char + diacritics)
          .join();
      final regex = RegExp(regexPattern, caseSensitive: false);

      // نقوم بتطبيق التلوين فقط على النصوص خارج الأوسمة < >
      content = content.splitMapJoin(
        RegExp(r'<[^>]*>'),
        onMatch: (m) => m.group(0)!, // نترك التاجات كما هي
        onNonMatch: (text) {
          // نلون النص العادي فقط
          return text.replaceAllMapped(regex, (match) {
            return '<span class="highlight">${match.group(0)}</span>';
          });
        },
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HadithContentWidget(htmlContent: content),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<HadithFavoritesCubit, HadithFavoritesState>(
                builder: (context, state) {
                  final isFav = context.read<HadithFavoritesCubit>().isFavorite(
                    hadith,
                  );
                  return IconButton(
                    onPressed: () {
                      context.read<HadithFavoritesCubit>().toggleFavorite(
                        hadith,
                      );
                      AppToast.show(
                        context,
                        isFav
                            ? 'تمت الإزالة من المفضلة'
                            : 'تمت الإضافة للمفضلة',
                      );
                    },
                    icon: Icon(
                      isFav ? SolarIconsBold.heart : SolarIconsOutline.heart,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () => _copyHadith(context),
                icon: const Icon(
                  SolarIconsOutline.copy,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () => _shareHadith(context),
                icon: const Icon(
                  SolarIconsOutline.share,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

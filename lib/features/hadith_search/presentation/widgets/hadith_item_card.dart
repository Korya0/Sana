import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_cubit.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_favorites/hadith_favorites_state.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_content_widget.dart';
import 'package:sana/features/hadith_search/presentation/widgets/hadith_share_card.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithItemCard extends StatelessWidget {
  const HadithItemCard({required this.hadith, super.key, this.searchQuery});
  final HadithEntity hadith;
  final String? searchQuery;

  Future<void> _copyHadith(BuildContext context) async {
    // تنسيق النص قبل النسخ ليظهر بشكل منظم في الحافظة
    var text = hadith.hadithContent
        .replaceAll(RegExp('<div class="divider">.*?</div>'), '\n---\n')
        .replaceAll(RegExp('</div>'), '\n')
        .replaceAll(RegExp('<[^>]*>'), '')
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
      widget: HadithShareCard(hadith: hadith),
      imageName: 'hadith_share',
    );
  }

  Color _getJudgmentColor(String? judgment) {
    if (judgment == null) return AppColors.gold;
    final j = judgment.toLowerCase();
    if (j.contains('صحيح') || j.contains('جيد') || j.contains('ثابت')) {
      return Colors.green.shade400;
    }
    if (j.contains('حسن')) {
      return AppColors.gold;
    }
    if (j.contains('ضعيف') ||
        j.contains('منكر') ||
        j.contains('لا يصح') ||
        j.contains('موضوع') ||
        j.contains('باطل') ||
        j.contains('كذب')) {
      return Colors.red.shade400;
    }
    return AppColors.gold;
  }

  @override
  Widget build(BuildContext context) {
    var content = hadith.hadithContent;
    final judgmentColor = _getJudgmentColor(hadith.judgment);

    // تمييز كلمة البحث مع تجاهل التشكيل بشكل آمن (لا يكسر الـ HTML)
    if (searchQuery != null && searchQuery!.trim().isNotEmpty) {
      final query = searchQuery!.trim();
      const diacritics = '[\u064B-\u0652]*';
      final regexPattern = query
          .split('')
          .map((char) => char + diacritics)
          .join();
      final regex = RegExp(regexPattern, caseSensitive: false);

      // نقوم بتطبيق التلوين فقط على النصوص خارج الأوسمة < >
      content = content.splitMapJoin(
        RegExp('<[^>]*>'),
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
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: judgmentColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Side Indicator
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(color: judgmentColor),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HadithContentWidget(
                    htmlContent: content,
                    judgmentColor: judgmentColor,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<HadithFavoritesCubit, HadithFavoritesState>(
                        builder: (context, state) {
                          final isFav = context
                              .read<HadithFavoritesCubit>()
                              .isFavorite(
                                hadith,
                              );
                          return IconButton(
                            onPressed: () async {
                              await context
                                  .read<HadithFavoritesCubit>()
                                  .toggleFavorite(
                                    hadith,
                                  );
                              if (!context.mounted) return;
                              AppToast.show(
                                context,
                                isFav
                                    ? 'تمت الإزالة من المفضلة'
                                    : 'تمت الإضافة للمفضلة',
                              );
                            },
                            icon: Icon(
                              isFav
                                  ? SolarIconsBold.heart
                                  : SolarIconsOutline.heart,
                              color: isFav ? Colors.white : AppColors.gold,
                              size: 20,
                            ),
                          );
                        },
                      ),
                      CombinedShareCopyButton(
                        onSharePressed: () => _shareHadith(context),
                        onCopyPressed: () => _copyHadith(context),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:solar_icons/solar_icons.dart';

class HadithSuggestionsGrid extends StatelessWidget {
  const HadithSuggestionsGrid({
    required this.onSuggestionTap,
    super.key,
    this.isInitial = false,
  });
  final ValueChanged<String> onSuggestionTap;
  final bool isInitial;

  static const Map<String, List<String>> categorizedSuggestions = {
    AppStrings.worship: [
      AppStrings.praySuggestion,
      AppStrings.fastSuggestion,
      AppStrings.zakatSuggestion,
      AppStrings.hajjSuggestion,
      AppStrings.qiyamSuggestion,
      AppStrings.wuduSuggestion,
    ],
    AppStrings.ethics: [
      AppStrings.parentsSuggestion,
      AppStrings.goodMannersSuggestion,
      AppStrings.honestySuggestion,
      AppStrings.trustSuggestion,
      AppStrings.mercySuggestion,
      AppStrings.backbitingSuggestion,
    ],
    AppStrings.creedAndSofteningOfHearts: [
      AppStrings.repentanceSuggestion,
      AppStrings.seekingForgivenessSuggestion,
      AppStrings.paradiseSuggestion,
      AppStrings.hellSuggestion,
      AppStrings.graveTrialSuggestion,
      AppStrings.faithSuggestion,
    ],
  };

  static const Map<String, IconData> categoryIcons = {
    AppStrings.worship: SolarIconsBold.starFallMinimalistic,
    AppStrings.ethics: SolarIconsBold.userHeart,
    AppStrings.creedAndSofteningOfHearts: SolarIconsBold.stars,
  };

  @override
  Widget build(BuildContext context) {
    if (isInitial) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.v8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getCategories(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.v16,
        vertical: AppSpacing.v8,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedBackgroundColor: context
              .color
              .secondaryScaffoldBackgroundColor
              .withValues(
                alpha: 0.4,
              ),
          backgroundColor: context.color.secondaryScaffoldBackgroundColor
              .withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          title: Text(
            AppStrings.suggestedTopics,
            style: AppTextStyles.font14W700(
              context,
            ).copyWith(color: context.color.textPrimary),
          ),
          leading: Icon(
            SolarIconsBold.stars,
            color: context.color.primary,
          ),
          childrenPadding: const EdgeInsets.only(bottom: AppSpacing.v12),
          children: _getCategories(),
        ),
      ),
    );
  }

  List<Widget> _getCategories() {
    return categorizedSuggestions.entries.map((entry) {
      final category = entry.key;
      final words = entry.value;
      final icon = categoryIcons[category] ?? SolarIconsBold.star;

      return _CategorySection(
        title: category,
        words: words,
        icon: icon,
        onSuggestionTap: onSuggestionTap,
      );
    }).toList();
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.title,
    required this.words,
    required this.icon,
    required this.onSuggestionTap,
  });

  final String title;
  final List<String> words;
  final IconData icon;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
          child: Row(
            children: [
              Icon(icon, size: AppSpacing.v20, color: context.color.primary),
              const SizedBox(width: AppSpacing.v8),
              Text(
                title,
                style: AppTextStyles.font14W700(
                  context,
                ).copyWith(color: context.color.textAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.v12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.v16),
          child: Wrap(
            spacing: AppSpacing.v8,
            children: words.map((text) {
              return ActionChip(
                onPressed: () {
                  unawaited(playVibrate());
                  onSuggestionTap(text);
                },
                backgroundColor: context.color.secondaryScaffoldBackgroundColor
                    .withValues(
                      alpha: 0.4,
                    ),
                surfaceTintColor: Colors.transparent,
                side: BorderSide(
                  color: context.color.primary.withValues(alpha: 0.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                label: Text(
                  text,
                  style: AppTextStyles.font12W500(
                    context,
                  ).copyWith(color: context.color.textPrimary),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.v20),
      ],
    );
  }
}

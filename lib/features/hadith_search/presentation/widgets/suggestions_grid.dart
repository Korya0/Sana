import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/core/utils/app_feedback.dart';
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
    AppStrings.worship: SolarIconsOutline.starFallMinimalistic,
    AppStrings.ethics: SolarIconsOutline.userHeart,
    AppStrings.creedAndSofteningOfHearts: SolarIconsOutline.stars,
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
          collapsedBackgroundColor: AppColors.secondaryBackground.withValues(
            alpha: 0.4,
          ),
          backgroundColor: AppColors.secondaryBackground.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          ),
          title: Text(
            AppStrings.suggestedTopics,
            style: AppTextStyles.font14W700White(
              context,
            ),
          ),
          leading: const Icon(
            SolarIconsOutline.stars,
            color: AppColors.primary,
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
      final icon = categoryIcons[category] ?? SolarIconsOutline.star;

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
              Icon(icon, size: AppSpacing.v20, color: AppColors.iconPrimary),
              const SizedBox(width: AppSpacing.v8),
              Text(title, style: AppTextStyles.font14W700primary(context)),
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
                  unawaited(AppFeedback.playVibrate());
                  onSuggestionTap(text);
                },
                backgroundColor: AppColors.secondaryBackground.withValues(
                  alpha: 0.4,
                ),
                surfaceTintColor: Colors.transparent,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                ),
                label: Text(
                  text,
                  style: AppTextStyles.font12W500White(context),
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


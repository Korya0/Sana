import 'package:flutter/material.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_type.dart';

/// Presentation-only icon mapping for [AzkarCategoryType].
///
/// The switch is exhaustive over the enum: adding a category without an icon
/// is a compile error instead of a silent numeric mismatch.
extension AzkarCategoryTypeIcon on AzkarCategoryType {
  IconData get icon => switch (this) {
    AzkarCategoryType.morning => AppIcons.morning,
    AzkarCategoryType.evening => AppIcons.evening,
    AzkarCategoryType.wakingUp => AppIcons.wakingUp,
    AzkarCategoryType.sleep => AppIcons.sleep,
    AzkarCategoryType.afterPrayer => AppIcons.afterPrayer,
    AzkarCategoryType.ablution => AppIcons.ablution,
    AzkarCategoryType.adhan => AppIcons.adhan,
    AzkarCategoryType.home => AppIcons.house,
    AzkarCategoryType.mosque => AppIcons.mosque,
    AzkarCategoryType.restroom => AppIcons.restroom,
    AzkarCategoryType.foodDrink => AppIcons.foodDrink,
    AzkarCategoryType.clothes => AppIcons.clothes,
    AzkarCategoryType.fasting => AppIcons.fasting,
    AzkarCategoryType.distressWorry => AppIcons.distress,
    AzkarCategoryType.repentance => AppIcons.repentance,
    AzkarCategoryType.praisingAllah => AppIcons.tasbih,
    AzkarCategoryType.marriage => AppIcons.marriage,
    AzkarCategoryType.children => AppIcons.children,
    AzkarCategoryType.sickness => AppIcons.sickness,
    AzkarCategoryType.death => AppIcons.death,
    AzkarCategoryType.funeral => AppIcons.funeral,
    AzkarCategoryType.travel => AppIcons.travel,
    AzkarCategoryType.openingSupplication => AppIcons.openingSupplication,
  };
}

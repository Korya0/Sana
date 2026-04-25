import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';

class HadithFormatter {
  HadithFormatter._();

  static String formatForCopy(String htmlContent) {
    final text = htmlContent
        .replaceAll(RegExp('<div class="divider">.*?</div>'), '\n---\n')
        .replaceAll(RegExp('</div>'), '\n')
        .replaceAll(RegExp('<[^>]*>'), '')
        .trim();

    return text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty || e == '---')
        .join('\n');
  }

  static Color getJudgmentColor(String? judgment) {
    if (judgment == null) return AppColors.gold;
    final j = judgment.toLowerCase();
    if (j.contains('صحيح') || j.contains('جيد') || j.contains('ثابت')) {
      return AppColors.success;
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
      return AppColors.error;
    }
    return AppColors.gold;
  }

  static String highlightSearchQuery(String content, String? searchQuery) {
    if (searchQuery == null || searchQuery.trim().isEmpty) return content;

    final query = searchQuery.trim();
    // Diacritics matching regex
    const diacritics = r'[\u064B-\u0652]*';
    final regexPattern = query
        .split('')
        .map((char) => char + diacritics)
        .join();
    final regex = RegExp(regexPattern, caseSensitive: false);

    return content.splitMapJoin(
      RegExp('<[^>]*>'),
      onMatch: (m) => m.group(0)!,
      onNonMatch: (text) {
        return text.replaceAllMapped(regex, (match) {
          return '<span class="highlight">${match.group(0)}</span>';
        });
      },
    );
  }
}

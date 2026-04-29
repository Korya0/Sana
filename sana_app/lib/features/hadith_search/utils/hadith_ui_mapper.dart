import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/hadith_search/data/models/hadith_judgment.dart';

extension HadithJudgmentExtension on HadithJudgment {
  Color get color {
    return switch (this) {
      HadithJudgment.sahih => AppColors.success,
      HadithJudgment.hasan => AppColors.primary,
      HadithJudgment.daeef => AppColors.red,
      HadithJudgment.unknown => AppColors.primary,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/hadith_search/data/models/hadith_judgment.dart';

extension HadithJudgmentExtension on HadithJudgment {
  Color getColor(BuildContext context) {
    return switch (this) {
      HadithJudgment.sahih => context.color.secondary,
      HadithJudgment.hasan => context.color.primary,
      HadithJudgment.daeef => context.color.error,
      HadithJudgment.unknown => context.color.primary,
    };
  }
}

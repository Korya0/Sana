import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/features/qibla/presentation/cubits/qibla/qibla_state.dart';

class QiblaMessageCard extends StatelessWidget {
  const QiblaMessageCard({
    required this.title,
    required this.subtitle,
    required this.tone,
    super.key,
  });

  final String title;
  final String subtitle;
  final QiblaGuidanceTone tone;

  @override
  Widget build(BuildContext context) {
    final titleStyle = switch (tone) {
      QiblaGuidanceTone.success => AppTextStyles.font16W700Brand(context),
      QiblaGuidanceTone.error => AppTextStyles.font16W700Error(context),
      QiblaGuidanceTone.normal => AppTextStyles.font16W700Primary(context),
    };
    final subtitleStyle = switch (tone) {
      QiblaGuidanceTone.success => AppTextStyles.font14W500Brand(context),
      QiblaGuidanceTone.error => AppTextStyles.font14W500Error(context),
      QiblaGuidanceTone.normal => AppTextStyles.font14W500Secondary(context),
    };

    return AppSectionCard(
      padding: EdgeInsets.all(AppSize.p20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle,
          ),
          AppGap.h(AppSize.p4),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: subtitleStyle,
          ),
        ],
      ),
    );
  }
}

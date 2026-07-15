import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';

class TeachingTopicDetailsBottomSheet extends StatelessWidget {
  const TeachingTopicDetailsBottomSheet({
    required this.sectionTitle,
    required this.topic,
    super.key,
  });

  final String sectionTitle;
  final TeachingPrayerTopicEntity topic;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = AppTextStyles.font14W500(context).copyWith(
      color: context.color.textPrimary,
      height: 1.8,
    );
    final highlightStyle = defaultStyle.copyWith(
      color: context.color.secondary,
      fontWeight: FontWeight.w700,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              sectionTitle,
              style: AppTextStyles.font20W700(
                context,
              ).copyWith(color: context.color.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          const AppGap.h(AppSpacing.v16),
          Text(
            topic.title,
            style: AppTextStyles.font16W500(
              context,
            ).copyWith(color: context.color.textSecondary),
            textAlign: TextAlign.start,
          ),
          const AppGap.h(AppSpacing.v24),
          Flexible(
            child: AppSectionCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.v16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: topic.points.map((point) {
                    return _TeachingPointWidget(
                      point: point,
                      defaultStyle: defaultStyle,
                      highlightStyle: highlightStyle,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeachingPointWidget extends StatelessWidget {
  const _TeachingPointWidget({
    required this.point,
    required this.defaultStyle,
    required this.highlightStyle,
  });

  final TeachingPointEntity point;
  final TextStyle defaultStyle;
  final TextStyle highlightStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.v12),
      child: RichText(
        text: TextSpan(
          children: point.spans.map((span) {
            return TextSpan(
              text: span.text,
              style: span.isHighlighted ? highlightStyle : defaultStyle,
            );
          }).toList(),
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

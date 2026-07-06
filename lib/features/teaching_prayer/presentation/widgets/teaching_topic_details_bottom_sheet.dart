import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
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
          const SizedBox(height: AppSpacing.v16),
          Center(
            child: Text(
              topic.title,
              style: AppTextStyles.font16W500(
                context,
              ).copyWith(color: context.color.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.v24),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.v16),
              decoration: BoxDecoration(
                color: context.color.secondaryScaffoldBackgroundColor
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(
                  color: context.color.secondaryScaffoldBackgroundColor,
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: topic.points.map((point) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.v12),
                      child: RichText(
                        text: TextSpan(
                          children: point.spans.map((span) {
                            return TextSpan(
                              text: span.text,
                              style: span.isHighlighted
                                  ? highlightStyle
                                  : defaultStyle,
                            );
                          }).toList(),
                        ),
                        textAlign: TextAlign.justify,
                      ),
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

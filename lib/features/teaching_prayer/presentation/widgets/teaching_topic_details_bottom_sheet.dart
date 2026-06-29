import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/teaching_prayer/data/models/teaching_prayer_model.dart';

class TeachingTopicDetailsBottomSheet extends StatelessWidget {
  const TeachingTopicDetailsBottomSheet({
    required this.sectionTitle,
    required this.topic,
    super.key,
  });

  final String sectionTitle;
  final TeachingPrayerTopicModel topic;

  @override
  Widget build(BuildContext context) {
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
              style: AppTextStyles.font20W700(context).copyWith(color: context.color.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.v16),
          Center(
            child: Text(
              topic.title,
              style: AppTextStyles.font16W500(context).copyWith(color: context.color.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.v24),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.v16),
              decoration: BoxDecoration(
                color: context.color.secondaryScaffoldBackgroundColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                border: Border.all(color: Colors.white10),
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
                          children: _buildHighlightedSpans(context, point.text),
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

  List<TextSpan> _buildHighlightedSpans(BuildContext context, String text) {
    final defaultStyle = AppTextStyles.font14W500(context).copyWith(
      color: context.color.textPrimary,
      height: 1.8,
    );
    final highlightStyle = defaultStyle.copyWith(
      color: Colors.green.shade400,
      fontWeight: FontWeight.w700,
    );

    final regex = RegExp(r'\(.*?\)');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return [TextSpan(text: text, style: defaultStyle)];
    }

    final spans = <TextSpan>[];
    var lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start), style: defaultStyle));
      }
      spans.add(TextSpan(text: match.group(0), style: highlightStyle));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: defaultStyle));
    }

    return spans;
  }
}

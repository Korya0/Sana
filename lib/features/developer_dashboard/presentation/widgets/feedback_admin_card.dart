import 'package:flutter/material.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/theme/app_spacing.dart';
import 'package:sana/features/developer_dashboard/domain/entities/feedback_entity.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart';
import 'package:sana/features/developer_dashboard/presentation/widgets/feedback_content.dart';

class FeedbackAdminCard extends StatelessWidget {
  const FeedbackAdminCard({
    required this.feedback,
    super.key,
  });

  final FeedbackEntity feedback;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        decoration: featureCardDecoration(
          context: context,
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Body of the feedback
            Padding(
              padding: const EdgeInsets.all(AppSpacing.v18),
              child: FeedbackContent(feedback: feedback),
            ),
            // Actions (Delete, Share) at the bottom
            AdminFeedbackActions(
              feedback: feedback,
            ),
          ],
        ),
      ),
    );
  }
}
